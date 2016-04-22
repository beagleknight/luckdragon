defmodule Luckdragon.DockerCloud.Container do
  alias __MODULE__

  defstruct proxy_ip: '', server_name: '', upstream_name: '', proxy_port: ''

  @interesting_vars [
    "LUCKDRAGON_PROXY_PORT",
    "LUCKDRAGON_SERVER_NAME",
    "LUCKDRAGON_UPSTREAM_NAME"
  ]

  def build_from_api(%{"private_ip" => private_ip, "container_envvars" => container_envvars}) do
    env = container_envvars 
          |> Enum.filter(fn(%{"key" => k}) -> k in @interesting_vars end)
          |> Enum.map(fn(%{"key" => k, "value" => v}) -> {String.to_atom(k),v} end)

    %Container{
      proxy_ip: private_ip,
      proxy_port: env[:LUCKDRAGON_PROXY_PORT],
      server_name: env[:LUCKDRAGON_SERVER_NAME],
      upstream_name: env[:LUCKDRAGON_UPSTREAM_NAME]
    }
  end
end
