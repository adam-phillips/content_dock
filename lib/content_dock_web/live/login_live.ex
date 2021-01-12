defmodule ContentDockWeb.LoginLive do
  use ContentDockWeb, :live_view

  require Logger

  def mount(_, _session, socket) do
    {:ok, socket}
  end

  def handle_event("login", %{"login" => %{"email" => email}}, socket) do
    case ContentDock.Accounts.handle_email_login(email, socket.endpoint.url()) do
      {:ok, token} ->
        Phoenix.PubSub.subscribe(ContentDock.PubSub, "login_token:#{token}")
        {:noreply, assign(socket, :token, token)}

      {:error, :user_not_found} ->
        Logger.warn("Failed login")
        {:noreply, socket}
    end
  end

  def handle_info({:login_token, token}, socket) do
    if socket.assigns.token && socket.assigns.token == token do
      Logger.info("Successfully logged in")
    else
      Logger.warn("WRONG TOKEN FOOL")
    end

    {:noreply, socket}
  end
end
