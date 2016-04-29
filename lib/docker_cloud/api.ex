defmodule Luckdragon.DockerCloud.Api do
  alias Luckdragon.Events
  alias Luckdragon.Processor
  alias Luckdragon.DockerCloud.Container

  @wss_address          "ws.cloud.docker.com"
  @api_address          "https://cloud.docker.com"
  @api_key              System.get_env("DOCKERCLOUD_AUTH")
  @nginx_service_name   System.get_env("LUCKDRAGON_NGINX_SERVICE_NAME")

  def listen_events do
    Events.start_link []
    spawn_link(Processor, :process, [])

    path = "/api/audit/v1/events"
    socket = Socket.Web.connect! @wss_address, path: path, api_key: @api_key, secure: true, custom_headers: %{Authorization: @api_key}

    socket
    |> receive_message
  end

  def get_containers do
    case request("/api/app/v1/container/") do
      {:ok, body} ->
        body
        |> Poison.decode!
        |> Map.get("objects")
        |> Enum.map(&Map.get(&1, "resource_uri"))
        |> Enum.map(&(Task.async(fn() -> get_container(&1) end)))
        |> Enum.map(&Task.await/1)
        |> Enum.filter(fn(%Container{server_name: server_name}) -> server_name !== nil end)
      {:error, reason} ->
        IO.puts "An error ocurred while fetching containers:"
        IO.puts reason
    end
  end

  def get_container(url) do
    case request(url) do
      {:ok, body} ->
        body
        |> Poison.decode!
        |> Map.take(["private_ip", "container_envvars"])
        |> Container.build_from_api
      {:error, reason} ->
        IO.puts "An error ocurred while fetching containers:"
        IO.puts reason
    end
  end

  def get_service(url) do
    case request(url) do
      {:ok, body} ->
        body
        |> Poison.decode!
        |> Map.take(["containers"])
      {:error, reason} ->
        IO.puts "An error ocurred while fetching containers:"
        IO.puts reason
    end
  end

  def get_nginx_containers do
    case request("/api/app/v1/service/") do
      {:ok, body} ->
        body
        |> Poison.decode!
        |> Map.get("objects")
        |> Enum.filter(fn(s) -> Map.get(s, "name") === @nginx_service_name end)
        |> List.first
        |> Map.get("resource_uri")
        |> get_service
        |> Map.get("containers")
      {:error, reason} ->
        IO.puts "An error ocurred while fetching containers:"
        IO.puts reason
    end
  end

  def reload_nginx_container(resource_uri) do
    path = "#{resource_uri}exec/?command=nginx%20-s%20reload"
    Socket.Web.connect! @wss_address, path: path, api_key: @api_key, secure: true, custom_headers: %{Authorization: @api_key}
  end

  defp request(url) do
    case HTTPoison.get("#{@api_address}#{url}", [
      "Authorization": @api_key, 
      "Accept": "application/json"
    ]) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body}
      {:ok, %HTTPoison.Response{status_code: 401, body: body}} ->
        {:error, body}
    end
  end

  defp receive_message(socket) do
    case socket |> Socket.Web.recv! do
      {:text, data} ->
        data
        |> Poison.Parser.parse!
        |> Events.enqueue
        receive_message(socket)
      {:close, _, _} ->
        IO.puts "Websocket connection closed"
    end
  end
end
