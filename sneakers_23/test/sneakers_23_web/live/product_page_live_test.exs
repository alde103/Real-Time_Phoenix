defmodule Sneakers23Web.ProductPageLiveTest do
  use Sneakers23Web.ConnCase, async: false
  import Phoenix.LiveViewTest
  alias Sneakers23.Inventory

  setup _ do
    {inventory, _data} = Test.Factory.InventoryFactory.complete_products()
    {:ok, _} = GenServer.call(Inventory, {:test_set_inventory, inventory})
    {:ok, %{inventory: inventory}}
  end

  test "the disconnected view renders the product HTML", %{conn: conn} do
    html = get(conn, "/drops") |> html_response(200)
    assert html =~ ~s(<main class="product-list">)
    assert html =~ ~s(coming soon...)
  end

  test "the live view connects", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/drops")
    assert html =~ ~s(<main class="product-list">)
    assert html =~ ~s(coming soon...)
  end

  test "product releases are picked up", %{conn: conn, inventory: inventory} do
    {:ok, view, html} = live(conn, "/drops")
    assert html =~ ~s(coming soon...)
    release_all(inventory)
    html = render(view)
    refute html =~ ~s(coming soon...)

    Enum.each(inventory.items, fn {id, _} ->
      assert html =~ ~s(name="item_id" value="#{id}")
    end)
  end

  test "sold out items are picked up", %{conn: conn, inventory: inventory} do
    {:ok, view, _html} = live(conn, "/drops")

    release_all(inventory)

    html = render(view)

    Enum.each(inventory.items, fn {id, _} ->
      assert html =~ ~s(name="item_id" value="#{id}")
    end)

    # {:ok, products} = Sneakers23.Inventory.get_complete_products()
    # IO.inspect(products)

    sell_all(inventory)

    # {:ok, products} = Sneakers23.Inventory.get_complete_products()
    # IO.inspect(products)
    Process.sleep(100)

    html = render(view)

    Enum.each(inventory.items, fn {id, _} ->
      assert html =~
               ~s(size-container__entry--level-out" name="item_id" value="#{id}")
    end)
  end

  defp release_all(%{products: products}) do
    products
    |> Map.keys()
    |> Enum.each(&Inventory.mark_product_released!(&1))
  end

  defp sell_all(%{availability: availability}) do
    availability
    |> Map.values()
    |> Enum.each(fn %{item_id: id, available_count: count} ->
      Enum.each(1..count, fn _ ->
        Sneakers23.Checkout.SingleItem.sell_item(id)
      end)
    end)
  end
end
