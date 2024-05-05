defmodule Sneakers23Web.Router do
  use Sneakers23Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Sneakers23Web.CartIdPlug
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :admin do
    plug :auth
    # plug :basic_auth, Application.compile_env(:sneakers_23, :admin_auth)
    plug :put_layout, html: {Sneakers23Web.Layouts, :admin}
  end

  pipeline :shopper do
    plug :put_root_layout, html: {Sneakers23Web.Layouts, :root}
  end

  scope "/", Sneakers23Web do
    pipe_through [:browser, :shopper]

    get "/", ProductController, :index
    get "/checkout", CheckoutController, :show
    post "/checkout", CheckoutController, :purchase
    get "/checkout/complete", CheckoutController, :success
  end

  scope "/admin", Sneakers23Web.Admin do
    pipe_through [:browser, :admin]
    get "/", DashboardController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", Sneakers23Web do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:sneakers_23, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: Sneakers23Web.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  defp auth(conn, _opts) do
    admin_auth = Application.get_env(:sneakers_23, :admin_auth)

    Plug.BasicAuth.basic_auth(conn,
      username: admin_auth[:username],
      password: admin_auth[:password]
    )
  end
end
