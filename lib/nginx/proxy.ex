defmodule Luckdragon.Nginx.Proxy do
  alias __MODULE__

  alias Luckdragon.DockerCloud.Container

  defstruct ip: '', port: ''

  def build_from_container(%Container{proxy_port: port, proxy_ip: ip}) do
    %Proxy{ip: ip, port: port}
  end
end
