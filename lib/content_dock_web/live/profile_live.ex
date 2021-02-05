defmodule ContentDockWeb.ProfileLive do
  use ContentDockWeb, :live_view

  @impl true
  def mount(_params, session, socket) do
    socket = assign_session(socket, session)
    {:ok, socket}
  end
end
