defmodule Sneakers23Web.ShoppingCartChannel do
  use Phoenix.Channel
  alias Sneakers23.Checkout
  import Sneakers23Web.CartHTML, only: [cart_to_map: 1]

  def join("cart:" <> id, params, socket) when byte_size(id) == 64 do
    cart = get_cart(params)
    socket = assign(socket, :cart, cart)
    send(self(), :send_cart)
    {:ok, socket}
  end

  def join("cart:" <> _id, _params, socket) do
    {:ok, socket}
  end

  def handle_info(:send_cart, socket = %{assigns: %{cart: cart}}) do
    push(socket, "cart", cart_to_map(cart))
    {:noreply, socket}
  end

  defp get_cart(params) do
    params
    |> Map.get("serialized", nil)
    |> Checkout.restore_cart()
  end
end
