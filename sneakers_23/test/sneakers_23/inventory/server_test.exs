defmodule Sneakers23.Inventory.ServerTest do
  use ExUnit.Case, async: true
  alias Sneakers23.Inventory.{Inventory, Server}

  defmodule FakeLoader do
    def load() do
      {:ok, Inventory.new()}
    end
  end

  describe "start_link/1" do
    test "the process starts and loads from the loader", %{test: test_name} do
      {:ok, pid} = Server.start_link(name: test_name, loader_mod: FakeLoader)
      assert :sys.get_state(pid) == Inventory.new()
    end
  end

  describe "get_inventory/1" do
    test "the inventory is returned", %{test: test_name} do
      {:ok, pid} = Server.start_link(name: test_name, loader_mod: FakeLoader)
      assert Server.get_inventory(pid) == {:ok, Inventory.new()}
    end
  end
end
