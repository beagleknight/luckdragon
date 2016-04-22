defmodule Luckdragon.Nginx.Upstream do
  alias __MODULE__

  alias Luckdragon.DockerCloud.Container
  alias Luckdragon.Nginx.Proxy

  defstruct name: '', proxies: []

  def build_from_container(container = %Container{upstream_name: name}) do
    proxy = container |> Proxy.build_from_container

    %Upstream{name: name, proxies: [proxy]}  
  end
end
