defmodule Sneakers23Web.CheckoutController do
  use Sneakers23Web, :controller

  def show(conn, %{"serialized_cart" => serialized_cart}) do
    cart = cart(serialized_cart)
    %{items: items} = Sneakers23Web.CartHTML.cart_to_map(cart)

    case items do
      [] ->
        render(conn, "empty.html")

      items ->
        conn
        |> assign(:items, items)
        |> assign(:serialized_cart, serialized_cart)
        |> assign(:cant_purchase?, cant_purchase?(items))
        |> render("show.html")
    end
  end

  def show(conn, _params), do: redirect(conn, to: ~p"/")

  def purchase(conn, params) do
    with serialized_cart <- Map.get(params, "serialized_cart"),
         cart <- cart(serialized_cart),
         %{items: items} when items != [] <- Sneakers23Web.CartHTML.cart_to_map(cart),
         {:availability, false} <- {:availability, has_out_of_stock_items?(items)},
         {:released, false} <- {:released, has_unreleased_items?(items)},
         {:purchase, {:ok, _}} <- {:purchase, Sneakers23.Checkout.purchase_cart(cart)} do
      redirect(conn, to: ~p"/checkout/complete")
    else
      %{items: []} ->
        conn
        |> put_flash(:error, "Your cart is empty")
        |> redirect(to: ~p"/checkout?#{params}")

      {:availability, true} ->
        conn
        |> put_flash(:error, "Your cart has out-of-stock shoes")
        |> redirect(to: ~p"/checkout?#{params}")

      {:released, true} ->
        conn
        |> put_flash(:error, "Your cart has unreleased shoes")
        |> redirect(to: ~p"/checkout?#{params}")

      {:purchase, _} ->
        conn
        |> put_flash(:error, "Your purchase could not be completed")
        |> redirect(to: ~p"/checkout?#{params}")
    end
  end

  def success(conn, _params) do
    conn
    |> render("success.html")
  end

  defp cart(serialized) do
    Sneakers23.Checkout.restore_cart(serialized)
  end

  defp cant_purchase?(items), do: has_out_of_stock_items?(items) || has_unreleased_items?(items)

  defp has_out_of_stock_items?(items), do: Enum.any?(items, & &1.out_of_stock)

  defp has_unreleased_items?(items), do: Enum.any?(items, &(!&1.released))
end
