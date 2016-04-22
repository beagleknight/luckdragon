defmodule Luckdragon do
  alias Luckdragon.DockerCloud

  def run do
    DockerCloud.Api.get_containers
  end
end
