defmodule A2S.Statem do
  @moduledoc """
  A state machine process responsible for handling all A2S queries to a game server running at the given address.
  Queries must be performed sequentially per address as A2S provides no way to associate what replies associate to what responses.

  Each instance should exit normally after a certain interval of inactivity (currently hard-coded to 2 minutes).
  """

  @behaviour :gen_statem

  require Logger

  @impl :gen_statem
  def callback_mode, do: :handle_event_function

  defmodule Data do
    @moduledoc false
    defstruct [:address, :caller, :query, :total, :parts]
  end

  ## Initialization

  @type init_args() :: {:inet.ip_address(), :inet.port_number()}

  @spec child_spec(init_args) :: Supervisor.child_spec()
  def child_spec(address) do
    # need to revisit this child specification
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [address]},
      restart: :transient
    }
  end

  @spec start_link(init_args) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(address) do
    :gen_statem.start_link(via_registry(address), __MODULE__, address, [])
  end

  @impl :gen_statem
  def init(address) do
    {:ok, :idle, %Data{address: address}, idle_timeout()}
  end

  ## Stopping

  @spec stop({:inet.ip_address(), :inet.port_number()}, any) :: :ok
  def stop(address, reason) do
    :gen_statem.stop(via_registry(address), reason, :infinity)
  end

  defp via_registry(address), do: {:via, Registry, {:a2s_registry, address}}

  ## State Machine Callbacks

  # Received a query to perform

  @impl :gen_statem
  def handle_event({:call, from}, query, :idle, data) do
    %Data{address: address} = data

    :ok = GenServer.call(A2S.UDP, {address, A2S.challenge_request(query)})

    {
      :next_state,
      :await_challenge,
      %Data{data | caller: from, query: query},
      recv_timeout()
    }
  end

  # A2S queries don't have IDs so they must be processed sequentially to avoid ambiguity.
  @impl :gen_statem
  def handle_event({:call, _from}, _query_type, _state, _data) do
    {:keep_state_and_data, :postpone}
  end

  # Received a packet

  @impl :gen_statem
  def handle_event(:cast, packet, :await_challenge, data) do
    %Data{
      address: address,
      query: query
    } = data

    case A2S.parse_challenge(packet) do
      {:immediate, msg} ->
        reply_and_next(msg, data)

      {:challenge, challenge} ->
        :ok = GenServer.call(A2S.UDP, {address, A2S.sign_challenge(query, challenge)})
        {:next_state, :await_response, data, recv_timeout()}

      {:multipacket, {header, _body} = part} ->
        {
          :next_state,
          :collect_multipacket,
          %Data{data | total: header.total, parts: [part]},
          recv_timeout()
        }
    end
  end

  @impl :gen_statem
  def handle_event(:cast, packet, :await_response, data) do
    case A2S.parse_response(packet) do
      {:multipacket, {header, _body} = part} ->
        {
          :next_state,
          :collect_multipacket,
          %Data{data | total: header.total, parts: [part]},
          recv_timeout()
        }

      # reply with whatever the result is.
      msg ->
        reply_and_next(msg, data)
    end
  end

  @impl :gen_statem
  def handle_event(:cast, packet, :collect_multipacket, data) do
    %Data{
      total: total,
      parts: parts
    } = data

    {:multipacket, part} = A2S.parse_response(packet)
    parts = [part | parts]

    if Enum.count(parts) === total do
      A2S.parse_multipacket_response(parts)
      |> reply_and_next(data)
    else
      {
        :next_state,
        :collect_multipacket,
        %Data{data | parts: parts},
        recv_timeout()
      }
    end
  end

  # Received a timeout

  @impl :gen_statem
  def handle_event(:state_timeout, :idle_timeout, :idle, _data) do
    {:stop, :normal}
  end

  @impl :gen_statem
  def handle_event(:state_timeout, :recv_timeout, _state, data) do
    reply_and_next({:error, :recv_timeout}, data)
  end

  defp reply_and_next(msg, %Data{address: address, caller: caller}) do
    :gen_statem.reply(caller, msg)

    {
      :next_state,
      :idle,
      %Data{address: address},
      recv_timeout()
    }
  end

  ## Timeout Definitions

  defp idle_timeout() do
    timeout = :persistent_term.get({__MODULE__, :idle_timeout})
    {:state_timeout, timeout, :idle_timeout}
  end

  defp recv_timeout() do
    timeout = :persistent_term.get({__MODULE__, :recv_timeout})
    {:state_timeout, timeout, :recv_timeout}
  end
end
