defmodule Sneakers23Web.CartTracker do
  use Phoenix.Presence,
    otp_app: :sneakers_23,
    pubsub_server: Sneakers23.PubSub

  @topic "admin:cart_tracker"
  def track_cart(socket, %{cart: cart, id: id, page: page}) do
    track(socket.channel_pid, @topic, id, %{
      page_loaded_at: System.system_time(:millisecond),
      page: page,
      items: Sneakers23.Checkout.cart_item_ids(cart)
    })
  end

  def update_cart(socket, %{cart: cart, id: id}) do
    update(socket.channel_pid, @topic, id, fn existing_meta ->
      Map.put(existing_meta, :items, Sneakers23.Checkout.cart_item_ids(cart))
    end)
  end

  def all_carts(), do: list(@topic)
end
