defmodule ObserverTestTest do
  use ExUnit.Case
  doctest ObserverTest

  test "greets the world" do
    assert ObserverTest.hello() == :world
  end
end
