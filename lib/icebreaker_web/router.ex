defmodule IcebreakerWeb.Router do
  use IcebreakerWeb, :router

  # TODO: Add Guardian pipeline

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {IcebreakerWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :maybe_auth do
    plug Icebreaker.Base.Guardian.Pipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  pipeline :ensure_not_auth do
    plug Guardian.Plug.EnsureNotAuthenticated
  end

  scope "/", IcebreakerWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/api", IcebreakerWeb.Api do
    pipe_through :api

    pipe_through :ensure_not_auth

    # * Register user
    post "/init", UserController, :init_verify
    post "/verify", UserController, :verify_token

    post "/refresh_token", UserController, :refresh_token

    pipe_through [:maybe_auth, :ensure_auth]

    post "/change", UserController, :change_user_data

    post "/locations", LocationController, :create
    patch "/locations", LocationController, :update
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: IcebreakerWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
