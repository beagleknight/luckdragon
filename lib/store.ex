defmodule Luckdragon.Store do
  alias Luckdragon.TemplateBuilder

  use GenServer

  ### GenServer API

  def init(state), do: {:ok, state}

  ### Client API / Helper methods

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
    spawn_link(TemplateBuilder, :build, [state])
  end
end
