defmodule Steinblick.Sources.BierSteinTest do
  use ExUnit.Case, async: true

  alias Steinblick.Sources.BierStein

  describe "parse/1" do
    test "finds every tap by number, including gaps" do
      html = File.read!("test/fixtures/bier_stein.html")

      taps = BierStein.parse(html)

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
  end
end
