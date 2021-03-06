defmodule ContentDockWeb.Router do
  use ContentDockWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ContentDockWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug(ContentDockWeb.Plugs.AssignCurrentUser)
  end

  pipeline :authenticated do
    plug ContentDockWeb.Plugs.RequireAuthentication
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
    get "/logout", Session, :logout

    get "/token/:token", Session, :submit_token
    get "/set_session/:token", Session, :set_session_user_id
  end

  scope "/profile", ContentDockWeb do
    pipe_through :browser
    pipe_through :authenticated

    live "/", ProfileLive, :profile
  end

  scope "/pages", ContentDockWeb do
    pipe_through :browser
    pipe_through :authenticated

    live "/blogs", BlogLive.Index, :index
    live "/blogs/new", BlogLive.Index, :new
    live "/blogs/:id/edit", BlogLive.Index, :edit

    live "/blogs/:id", BlogLive.Show, :show
    live "/blogs/:id/show/edit", BlogLive.Show, :edit
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
