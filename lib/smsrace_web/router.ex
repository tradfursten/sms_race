defmodule SmsraceWeb.Router do
  use SmsraceWeb, :router

  import SmsraceWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {SmsraceWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :external_api do
    plug :accepts, ["application/x-www-form-urlencoded"]
    plug Plug.Parsers,
      parsers: [:urlencoded]
  end

  scope "/", SmsraceWeb do
    pipe_through :browser


    live "/results/races/:id", RaceLive
    live "/results/checkpoints/:id", CheckpointLive
    live "/results/participants/:id", ParticipantLive
    live "/results/races", CurrentRacesLive
  end

  scope "/", SmsraceWeb do
    pipe_through [:browser, :require_authenticated_user]

    resources "/races", RaceController
    resources "/participants", ParticipantController
    resources "/checkpoints", CheckpointController

    live "/", PageLive, :index
    live "/organizations", OrganizationLive
  end

  scope "/", SmsraceWeb do
    pipe_through :external_api

    post "/incoming", ExternalApiController, :create
    post "/incoming_call", ExternalApiController, :incomming_call
  end

  # Other scopes may use custom stacks.
  # scope "/api", SmsraceWeb do
  #   pipe_through :api
  # end

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
      live_dashboard "/dashboard", metrics: SmsraceWeb.Telemetry
    end
  end

  ## Authentication routes

  scope "/", SmsraceWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", SmsraceWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/", SmsraceWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :confirm
  end
end
