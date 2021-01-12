defmodule ContentDockWeb.Login do
  use ContentDockWeb, :controller

  def submit_token(conn, %{"token" => token}) do
    Phoenix.PubSub.broadcast(ContentDock.PubSub, "login_token:#{token}", {:login_token, token})
    text(conn, "You made it in! Token: #{token}")
  end
end
