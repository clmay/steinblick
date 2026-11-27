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

  defp blank_to_nil(""), do: nil
  defp blank_to_nil(text), do: text

  defp clean(text), do: text |> String.replace(~r/\s+/u, " ") |> String.trim()

  defp parse_abv("ABV " <> number) do
    case Float.parse(number) do
      {abv, "%"} -> abv
      :error -> nil
    end
  end

  defp parse_price(row) do
    [size, "$" <> amount] =
      row
      |> LazyHTML.query("td")
      |> Enum.map(&LazyHTML.text/1)
      |> Enum.map(&clean/1)

    [dollars, cents] = String.split(amount, ".")

    %{price_cents: String.to_integer(dollars) * 100 + String.to_integer(cents), size: size}
  end

  defp parse_tap(item) do
    [heading, beer, origin] =
      item
      |> LazyHTML.query(".list-menu-item__head span")
      |> Enum.map(&LazyHTML.text/1)
      |> Enum.map(&clean/1)

    {number, "." <> brewery} = Integer.parse(heading)

    [description, abv | _] =
      item
      |> LazyHTML.query(".list-menu-item__body p")
      |> LazyHTML.text()
      |> String.split("|")
      |> Enum.map(&clean/1)

    {fill_percent, "%"} =
      item
      |> LazyHTML.query(".list-menu-item__progress strong")
      |> LazyHTML.text()
      |> clean()
      |> Integer.parse()

    prices =
      item
      |> LazyHTML.query(".list-menu-item__table tbody tr")
      |> Enum.map(&parse_price/1)

    %{
      abv: parse_abv(abv),
      beer: beer,
      brewery: String.trim(brewery),
      description: description,
      fill_percent: fill_percent,
      number: number,
      origin: blank_to_nil(origin),
      prices: prices
    }
  end
end
