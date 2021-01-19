defmodule ContentDockWeb.Router do
  use ContentDockWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ContentDockWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers

    # Plug (AssignCurrentUser) - set current user from User%{} from DB in the assign if present. .... if user_id in session, current_user = user from database
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ContentDockWeb do
    pipe_through :browser

    live "/", PageLive, :index

    live "/users", UserLive.Index, :index
    live "/users/new", UserLive.Index, :new
    live "/users/:id/edit", UserLive.Index, :edit

    live "/users/:id", UserLive.Show, :show
    live "/users/:id/show/edit", UserLive.Show, :edit
  end

  scope "/session", ContentDockWeb do
    pipe_through :browser

    live "/login", LoginLive, :login

    # Work on this
    # Create controller that takes this and broadcasts token over PubSub
    get "/token/:token", Login, :submit_token
    get "/set_session/:token", Login, :set_session_user_id
  end

  # Other scopes may use custom stacks.
  # scope "/api", ContentDockWeb do
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
      live_dashboard "/dashboard", metrics: ContentDockWeb.Telemetry
    end
  end
end
