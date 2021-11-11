defmodule IcebreakerWeb.Router do
  use IcebreakerWeb, :router
  alias IcebreakerWeb.Plug.Auth

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

  pipeline :session do
    plug Auth
  end

  scope "/", IcebreakerWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/api", IcebreakerWeb.Api do
    pipe_through :api

    # * Register user
    post "/init", UserController, :init_verify
    post "/verify", UserController, :verify_token
    post "/register", UserController, :register

    pipe_through :session

    # * Login user
    post "/login", UserController, :login

    resources "/locations", LocationController, except: [:new, :edit]
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
