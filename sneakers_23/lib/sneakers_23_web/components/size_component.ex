defmodule Sneakers23Web.SizeComponent do
  use Sneakers23Web, :live_component

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


  def product_size_options(product) do
    product.items
    |> Enum.map(fn item ->
      %{
        text: item.size,
        id: item.id,
        level: availability_to_level(item.available_count),
        disabled?: item.available_count == 0
      }
    end)
  end

  @spec availability_to_level(any()) :: <<_::24, _::_*8>>
  def availability_to_level(count) when count == 0, do: "out"
  def availability_to_level(count) when count < 150, do: "low"
  def availability_to_level(count) when count < 500, do: "medium"
  def availability_to_level(_), do: "high"
end
