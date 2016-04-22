defmodule Luckdragon.Transformer do
  alias Luckdragon.Nginx.Server
  use GenServer

  ### GenServer API

  def init(state), do: {:ok, state}

  def handle_cast({:transform, container}, state) do
    server = container |> Server.build_from_container

    IO.inspect server

    {:noreply, state ++ [server]}
  end


  ### Client API / Helper methods

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def transform(container), do: GenServer.cast(__MODULE__, {:transform, container})
end
