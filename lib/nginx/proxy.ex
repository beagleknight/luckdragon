defmodule Luckdragon.Nginx.Proxy do
  alias __MODULE__

  alias Luckdragon.DockerCloud.Container

  defstruct address: ''

  def build_from_container(%Container{proxy_port: port, proxy_ip: ip}) do
    %Proxy{address: "#{ip}:#{port}"}
  end
end
