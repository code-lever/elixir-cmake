defmodule ElixirCmakeTest do
  use ExUnit.Case
  doctest ElixirCmake

  test "greets the world" do
    assert ElixirCmake.hello() == :world
  end
end
