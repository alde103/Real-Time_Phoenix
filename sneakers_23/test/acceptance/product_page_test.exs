defmodule Acceptance.ProductPageTest do
  use Sneakers23.DataCase, async: false
  use Hound.Helpers

  alias Sneakers23.{Inventory, Repo}

  setup do
    metadata = Phoenix.Ecto.SQL.Sandbox.metadata_for(Repo, self())

    ua =
      "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36"

    chrome_options = %{
      "args" => ["--user-agent=#{ua}", "--headless", "--disable-gpu"],
      "binary" => "/usr/bin/google-chrome"
    }

    Hound.start_session(
      metadata: metadata,
      additional_capabilities: %{chromeOptions: chrome_options}
    )

    {inventory, _data} = Test.Factory.InventoryFactory.complete_products()
    {:ok, _} = GenServer.call(Inventory, {:test_set_inventory, inventory})
    :ok
  end

  test "the page updates when a product is released" do
    navigate_to("http://localhost:4002")

    [coming_soon, available] = find_all_elements(:css, ".product-listing")

    assert inner_text(coming_soon) =~ "coming soon..."
    assert inner_text(available) =~ "coming soon..."

    # Release the shoe
    {:ok, [_, product]} = Inventory.get_complete_products()
    Inventory.mark_product_released!(product.id)

    # The second shoe will have a size-container and no coming soon text
    assert inner_text(coming_soon) =~ "coming soon..."
    refute inner_text(available) =~ "coming soon..."

    refute inner_html(coming_soon) =~ "size-container"
    assert inner_html(available) =~ "size-container"
  end

  test "the page updates when a product reduces inventory" do
    {:ok, [_, product]} = Inventory.get_complete_products()

    Inventory.mark_product_released!(product.id)

    navigate_to("http://localhost:4002")

    [item_1, _item_2] = product.items

    assert [item_1_button] =
             find_all_elements(:css, ".size-container__entry[value='#{item_1.id}']")

    assert outer_html(item_1_button) =~ "size-container__entry--level-low"
    refute outer_html(item_1_button) =~ "size-container__entry--level-out"

    # Make the item be out of stock
    new_item_1 = Map.put(item_1, :available_count, 0)
    opts = [previous_item: item_1, current_item: new_item_1]
    Sneakers23Web.notify_item_stock_change(opts)

    refute outer_html(item_1_button) =~ "size-container__entry--level-low"
    assert outer_html(item_1_button) =~ "size-container__entry--level-out"
  end
end
