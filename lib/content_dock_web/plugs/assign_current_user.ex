defmodule ContentDockWeb.Plugs.AssignCurrentUser do
  @moduledoc """
  Assign current user if the current_user_id is present in the session
  """
  import Plug.Conn

  alias ContentDock.Accounts
  alias Plug.Conn

  @preloads [:roles]

  def init(opts), do: opts

  def call(%Conn{} = conn, _opts) do
    case get_session(conn, :current_user_id) do
      nil -> assign(conn, :current_user, nil)
      current_user_id -> assign(conn, :current_user, Accounts.get_user(current_user_id, @preloads))
    end
  end
end
