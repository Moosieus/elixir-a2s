defmodule A2S.Socket do
  @moduledoc false
  # GenServer wrapper over `:gen_udp` responsible for sending packets to game servers and routing received packets to the appropriate `A2S.Statem` process.

  use GenServer

  defmodule Data do
    @moduledoc false
    defstruct [:socket, :registry]
  end

  ## Initialization

  @spec start_link(keyword()) :: :ignore | {:error, any()} | {:ok, pid()}
  def start_link(opts) do
    name = name!(opts)
    port = port!(opts)
    registry = registry!(opts)

    GenServer.start_link(__MODULE__, {port, registry}, name: name)
  end

  defp name!(opts) do
    Keyword.get(opts, :name) || raise(ArgumentError, "must provide a name")
  end

  defp port!(opts) do
    Keyword.get(opts, :port) || raise(ArgumentError, "must provide a port for the UDP socket")
  end

  defp registry!(opts) do
    Keyword.get(opts, :a2s_registry) || raise(ArgumentError, "must provide an A2S registry")
  end

  @impl true
  def init({port, registry}) do
    case :gen_udp.open(port, [:binary, active: true]) do
      {:ok, socket} -> {:ok, %Data{socket: socket, registry: registry}}
      {:error, reason} -> {:stop, reason}
    end
  end

  ## Callbacks

  # Forward received packets to the appropriate `A2S.Statem`.
  @impl true
  def handle_info({:udp, _socket, ip, port, packet}, %Data{} = data) do
    GenServer.cast(via_registry(data.registry, {ip, port}), packet)
    {:noreply, data}
  end

  # Send the given `msg` packet to the game server.
  @impl true
  def handle_call({address, packet}, _from, %Data{} = data) do
    {:reply, :gen_udp.send(data.socket, address, packet), data}
  end

  ## Helpers

  defp via_registry(registry, name), do: {:via, Registry, {registry, name}}
end
