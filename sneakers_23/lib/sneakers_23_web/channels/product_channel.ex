defmodule Sneakers23Web.ProductChannel do
  use Phoenix.Channel
  # This allows sigil_p to be import.
  use Sneakers23Web, :verified_routes
  alias Sneakers23Web.{Endpoint, SizeComponent}

  def join("product:" <> _sku, %{}, socket) do
    {:ok, socket}
  end

  def notify_product_released(product = %{id: id}) do
    size_html =
      Phoenix.Template.render_to_string(SizeComponent, "render", "html", %{action:  ~p"/cart/add", product: product})

    Endpoint.broadcast!("product:#{id}", "released", %{
      size_html: size_html
    })
  end
end
