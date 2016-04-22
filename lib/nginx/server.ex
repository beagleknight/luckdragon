defmodule Luckdragon.Nginx.Server do
  alias __MODULE__

  alias Luckdragon.DockerCloud.Container
  alias Luckdragon.Nginx.Upstream

  defstruct name: '', use_ssl: false, upstream: %Upstream{}

  def build_from_container(container = %Container{server_name: name}) do
    upstream = container |> Upstream.build_from_container

    %Server{name: name, upstream: upstream}
  end
end
