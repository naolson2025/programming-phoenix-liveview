defmodule ProgrammingPhoenixLiveviewWeb.Router do
  use ProgrammingPhoenixLiveviewWeb, :router

  import ProgrammingPhoenixLiveviewWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ProgrammingPhoenixLiveviewWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ProgrammingPhoenixLiveviewWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  # scope "/api", ProgrammingPhoenixLiveviewWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:programming_phoenix_liveview, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ProgrammingPhoenixLiveviewWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", ProgrammingPhoenixLiveviewWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{ProgrammingPhoenixLiveviewWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", ProgrammingPhoenixLiveviewWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      # specify the root layout for all live routes in this scope
      # (this is the default, so you can omit it if you want)
      # root_layout: {ProgrammingPhoenixLiveviewWeb.Components.Layouts, :root},
      on_mount: [{ProgrammingPhoenixLiveviewWeb.UserAuth, :ensure_authenticated}] do
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email
      live "/guess", WrongLive
      live "/promo", PromoLive
      live "/survey", SurveyLive, :index
      live "/game/:puzzle", GameLive, :index
      live "/play", GameLive.Picker

      # add all product endpoints in the same sessions so we can
      # route between them without a page refresh
      live "/products", ProductLive.Index, :index
      live "/products/new", ProductLive.Index, :new
      live "/products/:id/edit", ProductLive.Index, :edit

      live "/products/:id", ProductLive.Show, :show
      live "/products/:id/show/edit", ProductLive.Show, :edit

      live "/admin/dashboard", Admin.DashboardLive, :index
    end
  end

  scope "/", ProgrammingPhoenixLiveviewWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{ProgrammingPhoenixLiveviewWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end
end
