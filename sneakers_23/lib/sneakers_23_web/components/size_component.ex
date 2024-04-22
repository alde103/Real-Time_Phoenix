defmodule Sneakers23Web.SizeComponent do
  use Sneakers23Web, :live_component

  import Sneakers23Web.ProductHTML, only: [product_size_options: 1]

  def render(assigns) do
    ~H"""
    <form class="size-container" action="/cart/add" method="POST">
    <%= for size <- product_size_options(@product) do %>
      <button
        type="submit"
        class={"size-container__entry
              size-container__entry--level-#{size.level}"}
        name="item_id"
        value={size.id}
        disable={if size.disabled?, do: "disabled", else: ""}
      >
        <%= size.text %>
      </button>
    <% end %>
  </form>
  """
  end
end
