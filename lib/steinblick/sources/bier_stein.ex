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
    [heading | _] =
      item
      |> LazyHTML.query(".list-menu-item__head span")
      |> Enum.map(&LazyHTML.text/1)

    {number, _rest} = Integer.parse(heading)

    %{number: number}
  end
end
