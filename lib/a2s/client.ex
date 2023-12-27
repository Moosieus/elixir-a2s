defmodule A2S.Client do
  @moduledoc """
  An easy to use client that performs the handshaking and busy-work necessary to make execute A2S queries.

  This client handles requests concurrently and should be suitable for most general uses.

  Note: must supply a :name
  """

  use Supervisor

  ## API

  def start_link(opts) do
    name = a2s_name!(opts)
    port = Keyword.get(opts, :port, 20850)
    idle_timeout = Keyword.get(opts, :idle_timeout, 120_000)
    recv_timeout = Keyword.get(opts, :recv_timeout, 3000)

    config = %{
      port: port,
      idle_timeout: idle_timeout,
      recv_timeout: recv_timeout
    }

    Supervisor.start_link(__MODULE__, config, name: supervisor_name(name))
  end

  def child_spec(opts) do
    %{
      id: a2s_name!(opts),
      start: {__MODULE__, :start_link, [opts]}
    }
  end

  @doc """
  Query a game server running at `address` for the data specified by `query`.
  """
  @spec query(:info | :players | :rules, {:inet.ip_address(), :inet.port_number()}, timeout) ::
          {:info, A2S.Info.t()}
          | {:players | A2S.Players.t()}
          | {:rules | A2S.Rules.t()}
          | {:error, any}
  def query(query, address, timeout \\ 5000) do
    :gen_statem.call(find_or_start(address), query, timeout)
  end

  ## CALLBACKS

  @impl true
  def init(config) do
    :persistent_term.put({A2S.Statem, :recv_timeout}, config.recv_timeout)
    :persistent_term.put({A2S.Statem, :idle_timeout}, config.idle_timeout)

    children = [
      {Registry, [keys: :unique, name: :a2s_registry]},
      {A2S.DynamicSupervisor, []},
      {A2S.UDP, [port: config.port]}
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end

  ## FUNCTIONS

  defp a2s_name!(opts) do
    Keyword.get(opts, :name) || raise(ArgumentError, "must supply a name")
  end

  defp supervisor_name(name), do: :"#{name}.Supervisor"

  @spec find_or_start({:inet.ip_address(), :inet.port_number()}) :: pid
  defp find_or_start(address) do
    case Registry.lookup(:a2s_registry, address) do
      [{pid, _value}] ->
        pid

      [] ->
        case A2S.DynamicSupervisor.start_child(address) do
          {:ok, pid} -> pid
          {:ok, pid, _info} -> pid
          {:error, {:already_started, pid}} -> pid
        end
    end
  end
end
