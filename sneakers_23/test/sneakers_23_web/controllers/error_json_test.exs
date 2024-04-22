defmodule Sneakers23Web.ErrorJSONTest do
  use Sneakers23Web.ConnCase, async: true

  test "renders 404" do
    assert Sneakers23Web.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert Sneakers23Web.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
