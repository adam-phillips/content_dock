defmodule ContentDockWeb.Plugs.RequireAuthentication do
  @behaviour Plug

  import Phoenix.Controller, only: [redirect: 2]
  import Plug.Conn, only: [halt: 1]

  alias ContentDock.Accounts.User
  alias ContentDockWeb.Router.Helpers, as: Routes
  alias Plug.Conn

  @impl Plug
  def init(opts) do
    opts
  end

  @impl Plug
  # def call(conn, _), do: raise(inspect(conn))
  def call(%Conn{assigns: %{current_user: %User{}}} = conn, _), do: conn

  def call(%Conn{} = conn, _),
    do: conn |> redirect(to: Routes.login_path(conn, :login, redirect: conn.request_path)) |> halt()
end
