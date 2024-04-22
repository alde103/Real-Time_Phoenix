defmodule Sneakers23Web.ProductHTML do
  use Sneakers23Web, :html

  embed_templates "product_html/*"

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

  def availability_to_level(count) when count == 0, do: "out"
  def availability_to_level(count) when count < 150, do: "low"
  def availability_to_level(count) when count < 500, do: "medium"
  def availability_to_level(_), do: "high"
end
