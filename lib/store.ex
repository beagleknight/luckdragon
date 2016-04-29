defmodule Luckdragon.Store do
  alias Luckdragon.Nginx.{Server, Upstream}
  alias Luckdragon.TemplateBuilder

  use GenServer

  ### GenServer API

  def init(state), do: {:ok, state}

  def handle_cast({:add, server}, state) do
    new_state = case Enum.any?(state, fn(s) -> server.name === s.name end) do
      true -> state |> Enum.map(fn(s) ->
                if server.name === s.name do
                  proxy = server.upstream.proxies |> List.first

                  %Server{
                    name: s.name,
                    use_ssl: s.use_ssl,
                    upstream: %Upstream{
                      name: s.upstream.name,
                      proxies: [proxy | s.upstream.proxies]
                    }
                  }
                else
                  s
                end
              end)
      _ ->
         state ++ [server]
    end

    TemplateBuilder.build(new_state)
    {:noreply, new_state}
  end

  def handle_cast({:remove, server}, state) do
    new_state = state 
    |> Enum.map(fn(s) ->
      proxy = server.upstream.proxies |> List.first

      %Server{
        name: s.name,
        use_ssl: s.use_ssl,
        upstream: %Upstream{
          name: s.upstream.name,
          proxies: s.upstream.proxies |> Enum.filter(fn(p) ->
            proxy.ip !== p.ip
          end)
        }
      }
    end)
    |> Enum.filter(fn(s) ->
      Enum.count(s.upstream.proxies) > 0
    end)

    TemplateBuilder.build(new_state)
    {:noreply, new_state}
  end

  ### Client API / Helper methods

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
    spawn_link(TemplateBuilder, :build, [state])
  end

  def add(server), do: GenServer.cast(__MODULE__, {:add, server})
  def remove(server), do: GenServer.cast(__MODULE__, {:remove, server})
end
