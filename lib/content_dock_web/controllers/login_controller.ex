defmodule ContentDockWeb.Login do
  use ContentDockWeb, :controller

  def submit_token(conn, %{"token" => token}) do
    Phoenix.PubSub.broadcast(ContentDock.PubSub, "login_token:#{token}", {:login_token, token})
    text(conn, "You made it in! Token: #{token}")
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
end
