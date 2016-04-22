defmodule Luckdragon do
  alias Luckdragon.Transformer
  alias Luckdragon.DockerCloud

  def run do
    Transformer.start_link []

    DockerCloud.Api.get_containers
    |> Enum.map(&Transformer.transform(&1))
  end
end
