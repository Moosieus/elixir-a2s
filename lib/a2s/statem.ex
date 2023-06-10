defmodule A2S.Statem do
  @moduledoc """
  A state machine process responsible for handling all A2S queries to a game server running at the given address. Queries must be performed sequentially per address, as A2S provides no way to associate what replies associate to what responses.

  Each instance should exit normally after a certain interval of inactivity (currently hard-coded to 2 minutes).
  """

  @type init_args() :: {:inet.ip_address(), :inet.port_number()}

  @behaviour :gen_statem

  require Logger

  @impl :gen_statem
  def callback_mode, do: :handle_event_function

  ## API

  @spec start_link(init_args) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(address) do
    :gen_statem.start_link(via_registry(address), __MODULE__, address, [])
  end

  @spec stop({:inet.ip_address(), :inet.port_number()}, any) :: :ok
  def stop(address, reason) do
    address |> via_registry |> GenServer.stop(reason)
  end

  @spec child_spec(init_args) :: Supervisor.child_spec()
  def child_spec(address) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [address]},
      restart: :transient
    }
  end

  ## Callbacks

  @impl :gen_statem
  def init(address) do
    {:ok, :idle, %{address: address, queue: []}, state_timeout()}
  end

  @impl :gen_statem
  def handle_event(:internal, :process_next, :idle, %{queue: []} = data) do
    {:keep_state, data, state_timeout()}
  end

  @impl :gen_statem
  def handle_event(:internal, :process_next, :idle, %{address: address, queue: [{caller, query} | queue]} = data) do
    :ok = GenServer.call(A2S.UDP, {address, A2S.challenge_request(query)})

    data = data
    |> Map.put(:caller, caller)
    |> Map.put(:query, query)

    {:next_state, :await_challenge, %{data | queue: queue}, recv_timeout()}
  end

  @impl :gen_statem
  def handle_event(:cast, packet, :await_challenge, %{address: address, caller: caller, query: query} = data) do
    case A2S.parse_challenge(packet) do
      {:challenge, challenge} ->
        :ok = GenServer.call(A2S.UDP, {address, A2S.sign_challenge(query, challenge)})
        {:next_state, :await_response, data, recv_timeout()}

      {:immediate, msg} ->
        reply_and_next(msg, caller, data)

      {:multipacket, {header, _body} = part} ->
        data = data
        |> Map.put(:total, header.total)
        |> Map.put(:parts, [part])

        {:next_state, :collect_multipacket, data, recv_timeout()}
    end
  end

  @impl :gen_statem
  def handle_event(:cast, packet, :await_response, %{caller: caller} = data) do
    case A2S.parse_response(packet) do
      {:multipacket, {header, _body} = part} ->
        data = data
        |> Map.put(:total, header.total)
        |> Map.put(:parts, [part])

        {:next_state, :collect_multipacket, data, recv_timeout()}

      msg ->
        reply_and_next(msg, caller, data)
    end
  end

  @impl :gen_statem
  def handle_event(:cast, packet, :collect_multipacket, %{caller: caller, total: total, parts: parts} = data) do
    {:multipacket, part} = A2S.parse_response(packet)
    parts = [part | parts]

    if Enum.count(parts) === total do
      data = clear_multipacket(data)

      parts
      |> A2S.parse_multipacket_response()
      |> reply_and_next(caller, data)
    else
      {:next_state, :collect_multipacket, %{data | parts: parts}, recv_timeout()}
    end
  end

  # Add requests to queue

  @impl :gen_statem
  def handle_event({:call, caller}, query_type, :idle, %{queue: []} = data) do
    {:keep_state, %{data | queue: [{caller, query_type}]}, [{:next_event, :internal, :process_next}, recv_timeout()]}
  end

  @impl :gen_statem
  def handle_event({:call, caller}, query_type, _state, %{queue: queue} = data) do
    {:keep_state, %{data | queue: queue ++ {caller, query_type}}, recv_timeout()}
  end

  ## Timeouts

  def handle_event(:state_timeout, :idle_timeout, :idle, _data) do
    {:stop, :normal}
  end

  def handle_event(:state_timeout, :recv_timeout, _state, %{caller: caller} = data) do
    data = clear_multipacket(data)
    reply_and_next({:error, :recv_timeout}, caller, data)
  end

  ## Functions

  defp reply_and_next(msg, caller, data) do
    :gen_statem.reply(caller, msg)
    data = clear_query(data)
    {:next_state, :idle, data, [{:next_event, :internal, :process_next}, recv_timeout()]}
  end

  defp clear_query(data), do: data |> Map.delete(:caller) |> Map.delete(:query)

  defp clear_multipacket(data), do: data |> Map.delete(:total) |> Map.delete(:parts)

  defp state_timeout() do
    timeout = :persistent_term.get({__MODULE__, :idle_timeout})
    {:state_timeout, timeout, :idle_timeout}
  end

  defp recv_timeout() do
    timeout = :persistent_term.get({__MODULE__, :recv_timeout})
    {:state_timeout, timeout, :recv_timeout}
  end

  defp via_registry(address), do: {:via, Registry, {:a2s_registry, address}}
end
