defmodule Luckdragon do
  alias Luckdragon.Store
  alias Luckdragon.Nginx.Server
  alias Luckdragon.DockerCloud.Api

  def run do
    Api.get_containers
    |> Enum.map(&Server.build_from_container(&1))
    |> Store.start_link
  end
end
