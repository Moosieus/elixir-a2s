defmodule A2S.Client do
  @moduledoc """
  An easy to use client that performs the packet assembly necessary to execute A2S queries.

  This client handles requests concurrently and should be suitable for most general uses.

  Note: must supply a `:name`.
  """

  use Supervisor

  @default_name A2S_Singleton

  defmodule Config do
    @moduledoc false
    defstruct [:name, :port, :idle_timeout, :recv_timeout]
  end

  ## Initialization

  def child_spec(opts) do
    %{
      id: a2s_name(opts),
      start: {__MODULE__, :start_link, [opts]}
    }
  end

  @doc """
  The following configuration options are available:

  * `:name` - Alias of the top-level supervisor. Can be provided if you intend to run multiple client instances. Defaults to `#{inspect(@default_name)}`.

  * `:port` - UDP socket port used for querying game servers. Defaults to `20850`.

  * `:idle_timeout` - `A2S.Client` internally allocates a `:gen_statem` for each address queried, that should exit after idling to keep from leaking resources. Defaults to `120_000` or 2 minutes.

  * `:recv_timeout` - Timeout the `:gen_statem`'s will wait between receiving individual packets before returning `{:error, :recv_timeout}`. Defaults to `3000` or 3 seconds.
  """
  @spec start_link(keyword()) :: :ignore | {:error, any()} | {:ok, pid()}
  def start_link(opts \\ []) do
    name = a2s_name(opts)

    config = %Config{
      name: name,
      port: Keyword.get(opts, :port, 20850),
      idle_timeout: Keyword.get(opts, :idle_timeout, 120_000),
      recv_timeout: Keyword.get(opts, :recv_timeout, 3000)
    }

    Supervisor.start_link(__MODULE__, config, name: supervisor_name(name))
  end

  defp a2s_name(opts), do: Keyword.get(opts, :name, @default_name)

  @impl true
  def init(%Config{} = config) do
    %Config{
      name: name,
      port: port,
      idle_timeout: idle_timeout,
      recv_timeout: recv_timeout
    } = config

    :persistent_term.put({A2S.Statem, :recv_timeout}, recv_timeout)
    :persistent_term.put({A2S.Statem, :idle_timeout}, idle_timeout)

    children = [
      {Registry, [keys: :unique, name: registry_name(name)]},
      {A2S.DynamicSupervisor, [name: dynamic_supervisor_name(name)]},
      {A2S.Socket, [name: socket_name(name), port: port, a2s_registry: registry_name(name)]}
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end

  ## API

  @doc """
  Query a game server running at `address` for the data specified by `query`.

  Additional options are available as a keyword list:
  * `:name` - Alias of the top-level supervisor. Defaults to `A2S.Client`.

  * `:timeout` - Absolute timeout for the request to complete. Defaults to `5000` or 5 seconds.
  """
  @spec query(
          :info | :players | :rules,
          {:inet.ip_address(), :inet.port_number()},
          list({atom(), any()})
        ) ::
          {:info, A2S.Info.t()}
          | {:players | A2S.Players.t()}
          | {:rules | A2S.Rules.t()}
          | {:error, any}

  def query(query, address, opts \\ []) do
    client_name = Keyword.get(opts, :name, @default_name)
    timeout = Keyword.get(opts, :timeout, 5000)

    :gen_statem.call(find_or_start(address, client_name), query, timeout)
  end

  defp find_or_start(address, client) do
    registry = registry_name(client)

    case Registry.lookup(registry, address) do
      [{pid, _value}] ->
        pid

      [] ->
        case A2S.DynamicSupervisor.start_child(address, client) do
          {:ok, pid} -> pid
          {:ok, pid, _info} -> pid
          {:error, {:already_started, pid}} -> pid
        end
    end
  end

  ## Helpers

  @doc false
  def registry_name(name), do: :"#{name}.Registry"

  @doc false
  def dynamic_supervisor_name(name), do: :"#{name}.DynamicSupervisor"

  @doc false
  def socket_name(name), do: :"#{name}.Socket"

  @doc false
  def supervisor_name(name), do: :"#{name}.Supervisor"
end
