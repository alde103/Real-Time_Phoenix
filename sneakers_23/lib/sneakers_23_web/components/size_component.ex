defmodule Sneakers23Web.SizeComponent do
  use Sneakers23Web, :live_component

  def render(assigns) do
    ~H"""
    <%= if @product.action do %>
      <.header>
        <.error>
        Unfortunately, there are errors in your submission. Please correct them below.
        </.error>
      </.header>
    <% end %>

    <.simple_form for={@product} phx-submit="save" action={@action}>
      <.input name="_csrf_token" type="hidden" hidden value={Plug.CSRFProtection.get_csrf_token()} />

      <%= for size <- product_size_options(@product) do %>
        <button
          type="submit"
          class={"size-container__entry
                size-container__entry--level-#{size.level}"}
          name="item_id"
          value={size.id}
          diabled={if size.disabled?, do: "disabled", else: ""}
        >
          <%= size.text %>
        </button>
      <% end %>

      <:actions>
        <.button>Save</.button>
        <.back navigate={~p"/products"}>Back to products</.back>
      </:actions>
    </.simple_form>
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

  def availability_to_level(count) when count == 0, do: "out"
  def availability_to_level(count) when count < 150, do: "low"
  def availability_to_level(count) when count < 500, do: "medium"
  def availability_to_level(_), do: "high"
end
