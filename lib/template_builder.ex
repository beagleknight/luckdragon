defmodule Luckdragon.TemplateBuilder do
  @src_file "templates/nginx.conf.eex"
  @out_file "tmp/nginx.conf"

  def build(servers) do
    case File.read @src_file do
      {:ok, content} ->
        case File.open @out_file, [:write] do
          {:ok, file} ->
            content = EEx.eval_string content, [servers: servers]
            IO.binwrite file, content
          {:error, reason} ->
            IO.puts "Error: #{reason}"
        end
      {:error, reason} ->
        IO.puts "Error: #{reason}"
    end
  end
end
