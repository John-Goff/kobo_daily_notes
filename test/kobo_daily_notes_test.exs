defmodule KoboDailyNotesTest do
  use ExUnit.Case
  doctest KoboDailyNotes

  test "greets the world" do
    assert KoboDailyNotes.hello() == :world
  end
end
