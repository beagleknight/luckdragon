defmodule Luckdragon.Nginx.Reloader do
  alias Luckdragon.DockerCloud.Api
  use GenServer

  ### GenServer API

  def init(state), do: {:ok, state}

  def handle_cast({:reload}, state) do
    state
    |> Enum.map(&Api.reload_nginx_container(&1))
    {:noreply, state}
  end


  ### Client API / Helper methods

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def reload, do: GenServer.cast(__MODULE__, {:reload})
end
