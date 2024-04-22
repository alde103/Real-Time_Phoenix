defmodule Sneakers23.Inventory.DatabaseLoader do
  alias Sneakers23.Inventory.{Inventory, Store}

  def load() do
    inventory =
      Inventory.new()
      |> Inventory.add_products(Store.all_products())
      |> Inventory.add_items(Store.all_items())
      |> Inventory.add_availabilities(Store.all_item_availabilities())

    {:ok, inventory}
  end
end
