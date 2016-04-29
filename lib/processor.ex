defmodule Luckdragon.Processor do
  alias Luckdragon.Events
  alias Luckdragon.Store
  alias Luckdragon.Nginx.Server
  alias Luckdragon.DockerCloud.Api

  def process do
    Events.dequeue
    |> process_event
  end

  defp process_event(event = %{"state" => "Terminated", "type" => "container"}) do
    Api.get_container(event["resource_uri"])
    |> Server.build_from_container
    |> Store.remove
    process
  end

  defp process_event(event = %{"state" => "Running", "type" => "container"}) do
    Api.get_container(event["resource_uri"])
    |> Server.build_from_container
    |> Store.add
    process
  end

  defp process_event(_), do: process
end
