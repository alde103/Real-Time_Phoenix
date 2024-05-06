defmodule MemoryTest do
  use ExUnit.Case
  doctest Memory

  test "greets the world" do
    assert Memory.hello() == :world
  end
end
