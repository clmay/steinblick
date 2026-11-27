defmodule Steinblick.Sources.BierStein do
  @moduledoc """
  Reads the tap list at https://thebierstein.com/draft-bottles/.
  """

  def parse(html) do
    html
    |> LazyHTML.from_document()
    |> LazyHTML.query(".list-menu-item")
    |> Enum.map(&parse_tap/1)
  end

  defp parse_tap(item) do
    [heading, beer, origin] =
      item
      |> LazyHTML.query(".list-menu-item__head span")
      |> Enum.map(&LazyHTML.text/1)
      |> Enum.map(&String.trim/1)

    {number, rest} = Integer.parse(heading)

    %{
      number: number,
      brewery: rest |> String.trim_leading(".") |> String.trim(),
      beer: beer,
      origin: blank_to_nil(origin)
    }
  end

  defp blank_to_nil(""), do: nil
  defp blank_to_nil(text), do: text
end
