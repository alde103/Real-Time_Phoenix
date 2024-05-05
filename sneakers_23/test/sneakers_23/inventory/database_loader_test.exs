defmodule Sneakers23.Inventory.DatabaseLoaderTest do
  use Sneakers23.DataCase, async: false

  alias Sneakers23.Inventory.{DatabaseLoader, Inventory}

  describe "load/0" do
    test "an empty inventory can be loaded" do
      assert DatabaseLoader.load() == {:ok, Inventory.new()}
    end

    test "all records are loaded" do
      {expected, _} = Test.Factory.InventoryFactory.complete_products()
      assert DatabaseLoader.load() == {:ok, expected}
    end
  end
end
