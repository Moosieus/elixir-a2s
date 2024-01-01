defmodule A2S.DynamicSupervisor do
  @moduledoc false
  # Singleton dynamic supervisor for `A2S.Statem` processes.

  use DynamicSupervisor

  ## Initialization

  @spec start_link(any) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(opts) do

    name = Keyword.fetch!(opts, :name)

    DynamicSupervisor.start_link(__MODULE__, [], name: name)
  end

  @impl true
  def init(_arg), do: DynamicSupervisor.init(strategy: :one_for_one)

  ## API

  # Starts an `A2S.Statem` for the specified `address`.
  @spec start_child({:inet.ip_address(), :inet.port_number()}, term()) ::
    :ignore | {:error, any} | {:ok, pid} | {:ok, pid, any}

  def start_child(address, client) do
    registry = A2S.Client.registry_name(client)
    supervisor = A2S.Client.dynamic_supervisor_name(client)

    DynamicSupervisor.start_child(supervisor, {A2S.Statem, {address, registry}})
  end
end
