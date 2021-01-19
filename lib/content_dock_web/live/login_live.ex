defmodule ContentDockWeb.LoginLive do
  use ContentDockWeb, :live_view

  require Logger

  def mount(_, session, socket) do
    socket =
      socket
      |> assign(:logging_in, true)
      |> assign(:current_user_id, session["current_user_id"])

    {:ok, socket}
  end

  def handle_event("login", %{"login" => %{"email" => email}}, socket) do
    socket =
      case ContentDock.Accounts.handle_email_login(email, socket.endpoint.url()) do
        {:ok, {token, id}} ->
          Phoenix.PubSub.subscribe(ContentDock.PubSub, "login_token:#{token}")

          socket
          |> assign(:token, token)
          |> assign(:user_id, id)

        {:error, :user_not_found} ->
          Logger.warn("Failed login")
          socket
      end

    {:noreply, assign(socket, :logging_in, false)}
  end

  def handle_info({:login_token, token}, socket) do
    socket =
      if socket.assigns.token && socket.assigns.token == token do
        Logger.info("Successfully logged in")
        set_session_user_id(socket)
      else
        Logger.warn("WRONG TOKEN FOOL")
        socket
      end

    {:noreply, socket}
  end

  def set_session_user_id(socket) do
    token =
      Phoenix.Token.sign(ContentDockWeb.Endpoint, "login_token_validated", socket.assigns.user_id)

    push_event(socket, "login_token_validated", %{token: token})
  end
end
