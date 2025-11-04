defmodule PhoenixreactWeb.Router do
  use PhoenixreactWeb, :router

  import PhoenixreactWeb.MetaTags
  import PhoenixreactWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {PhoenixreactWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_scope_for_user
  end

  pipeline :browser_marketing do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {PhoenixreactWeb.Layouts, :root_marketing}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :set_meta_tag_values
    plug Inertia.Plug
  end

  pipeline :browser_admin do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {PhoenixreactWeb.Layouts, :root_admin}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_scope_for_user
    plug :set_meta_tag_values
    plug Inertia.Plug
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PhoenixreactWeb do
    pipe_through :browser

    get "/phoenix", PageController, :home
  end

  # --- Marketing pages ---
  scope "/", PhoenixreactWeb do
    pipe_through :browser_marketing

    get "/", MarketingController, :home
    get "/pricing", MarketingController, :pricing
  end

  # --- Admin pages ---
  scope "/app", PhoenixreactWeb do
    pipe_through :browser_admin

    get "/sign_in/:token", UserSessionController, :confirm
    post "/sign_in", UserSessionController, :create
    get "/sign_in", UserSessionController, :new
  end

  scope "/app", PhoenixreactWeb do
    pipe_through [:browser_admin, :require_authenticated_user]

    get "/", AdminController, :dashboard
    delete "/log_out", UserSessionController, :delete

    get "/settings", UserSettingsController, :edit
    put "/settings", UserSettingsController, :update
    get "/settings/confirm-email/:token", UserSettingsController, :confirm_email
  end

  scope "/app", PhoenixreactWeb do
    pipe_through [:browser_admin, :redirect_if_user_is_authenticated]

    get "/sign_up", UserRegistrationController, :new
    post "/sign_up", UserRegistrationController, :create
  end

  # Other scopes may use custom stacks.
  # scope "/api", PhoenixreactWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:phoenixreact, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: PhoenixreactWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
