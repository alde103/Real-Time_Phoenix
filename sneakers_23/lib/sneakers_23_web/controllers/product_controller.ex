defmodule Sneakers23Web.ProductController do
  use Sneakers23Web, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def index(conn, _params) do
    {:ok, products} = Sneakers23.Inventory.get_complete_products()

    render(conn, "index.html",  layout: false,  products: products)
  end
end
