defmodule Steinblick.Sources.BierSteinTest do
  use ExUnit.Case, async: true

  alias Steinblick.Sources.BierStein

  setup_all do
    %{taps: BierStein.parse(File.read!("test/fixtures/bier_stein.html"))}
  end

  describe "parse/1" do
    test "finds every tap by number, including gaps", %{taps: taps} do
      assert Enum.map(taps, & &1.number) ==
               [
                 1,
                 2,
                 3,
                 4,
                 5,
                 6,
                 7,
                 9,
                 10,
                 11,
                 12,
                 13,
                 15,
                 16,
                 17,
                 18,
                 19,
                 20,
                 21,
                 22,
                 23,
                 26,
                 27
               ]
    end

    test "reads brewery, beer and origin from each tap's heading", %{taps: taps} do
      assert %{brewery: "Bitburger", beer: "Drive N/A", origin: "Bitburg, Germany"} =
               Enum.find(taps, &(&1.number == 1))

      assert %{brewery: "Caldera", beer: "Root Beer", origin: nil} =
               Enum.find(taps, &(&1.number == 26))
    end

    test "trims stray whitespace from text", %{taps: taps} do
      assert %{origin: "Camas, WA"} = Enum.find(taps, &(&1.number == 2))
    end

    test "reads the description, with runs of spaces collapsed", %{taps: taps} do
      assert %{description: "Non-Alcoholic Pilsner"} = Enum.find(taps, &(&1.number == 1))

      assert %{description: "IPA - Hops (Citra, Simcoe, Centennial & Citra Cryo)"} =
               Enum.find(taps, &(&1.number == 3))
    end

    test "reads ABV as a number, or nil when the page leaves it blank", %{taps: taps} do
      assert Enum.find(taps, &(&1.number == 1)).abv == 0.0
      assert Enum.find(taps, &(&1.number == 2)).abv == 5.8
      assert Enum.find(taps, &(&1.number == 26)).abv == nil
    end
  end
end
