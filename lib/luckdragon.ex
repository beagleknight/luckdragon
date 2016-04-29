defmodule Luckdragon do
  alias Luckdragon.Store
  alias Luckdragon.Nginx.{Reloader, Server}
  alias Luckdragon.DockerCloud.Api

  def run do
    Store.start_link []

    Api.get_nginx_containers
    |> Reloader.start_link

    Api.get_containers
    |> Enum.map(&Server.build_from_container(&1))
    |> Enum.each(&Store.add(&1))

    Api.listen_events
  end
end
