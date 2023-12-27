defmodule A2S.DynamicSupervisor do
  @moduledoc """
  Singleton dynamic supervisor for `A2S.Statem` processes.
  """

  use DynamicSupervisor

  ## API

  @spec start_link(any) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(_arg) do
    DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  @doc """
  Starts an `A2S.Statem` for the specified `address`.
  """
  @spec start_child({:inet.ip_address(), :inet.port_number()}) ::
          :ignore | {:error, any} | {:ok, pid} | {:ok, pid, any}
  def start_child(address) do
    DynamicSupervisor.start_child(__MODULE__, {A2S.Statem, address})
  end

  ## Callbacks

  @impl true
  def init(_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
