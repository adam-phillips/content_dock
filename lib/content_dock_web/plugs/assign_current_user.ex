defmodule ContentDockWeb.Plugs.AssignCurrentUser do
  @moduledoc """
  Assign current user if the current_user_id is present in the session
  """
  import Plug.Conn

  alias ContentDock.Accounts

  def init(opts), do: opts

  def call(conn, _opts) do
    cond do
      # TODO: Clean up user data in session to limit what's sent over the wire
      user =
          get_session(conn, :current_user_id) &&
            Accounts.get_user_with_roles(get_session(conn, :current_user_id)) ->
        put_session(conn, :current_user, user)

      true ->
        put_session(conn, :current_user, nil)
    end
  end
end
