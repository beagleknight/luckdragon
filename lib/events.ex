defmodule Luckdragon.Events do
  use GenServer

  ### GenServer API

  def init(state), do: {:ok, state}

  def handle_call(:dequeue, _from, []), do: {:reply, nil, []}

  def handle_call(:dequeue, _from, [value|state]) do
    {:reply, value, state}
  end

  def handle_cast({:enqueue, value}, state) do
    {:noreply, state ++ [value]}
  end


  ### Client API / Helper methods

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def enqueue(value), do: GenServer.cast(__MODULE__, {:enqueue, value})
  def dequeue, do: GenServer.call(__MODULE__, :dequeue)
end
