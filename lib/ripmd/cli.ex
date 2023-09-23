defmodule Ripmd.CLI do
  require Logger

  def main(args) do
    Logger.info("Starting Ripmd")
    {switches, files, _} = parse_args(args)

    input = files |> List.first()
    output = files |> Enum.at(1, "output.html")

    Ripmd.livemd_to_html(input, output, switches)
  end

  defp parse_args(args) do
    args
    |> OptionParser.parse(strict: [])
    |> case do
      {_, _, []} = args -> args
      {_, _, _} -> System.halt(1)
    end
  end
end
