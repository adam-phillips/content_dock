defmodule ContentDockWeb.Session do
  use ContentDockWeb, :controller

  def submit_token(conn, %{"token" => token}) do
    Phoenix.PubSub.broadcast(ContentDock.PubSub, "login_token:#{token}", {:login_token, token})
    text(conn, "You've successfully logged in. Please close this tab and return to the main page.")
  end

  def set_session_user_id(conn, %{"token" => token}) do
    case Phoenix.Token.verify(ContentDockWeb.Endpoint, "login_token_validated", token, max_age: 15) do
      {:ok, user_id} ->
        conn
        |> put_session(:current_user_id, user_id)
        |> text("ok")

      {:error, _reason} ->
        conn
        |> text("error")
    end
  end

  def logout(conn, _opts) do
    conn
    |> put_session(:current_user_id, nil)
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
