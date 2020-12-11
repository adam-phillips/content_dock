defmodule ContentDockWeb.LoginLive do
  use ContentDockWeb, :live_view

  def mount(_, _session, socket) do
    {:ok, socket}
  end

  def handle_event("login", %{"login" => %{"email" => email}}, socket) do
    ContentDock.Accounts.handle_email_login(email, socket.endpoint.url())
    {:noreply, socket}
  end
end
