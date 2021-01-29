defmodule ContentDockWeb.PageLive do
  use ContentDockWeb, :live_view

  @impl true
  def mount(_params, session, socket) do
    socket = assign_session(socket, session)
    {:ok, socket}
  end

  def assign_session(%Phoenix.LiveView.Socket{} = socket, %{} = session) do
    socket
    |> assign_new(:current_user, fn ->
      case Map.fetch(session, "current_user_id") do
        {:ok, id} when not is_nil(id) -> id |> ContentDock.Accounts.get_user()
        _ -> nil
      end
    end)
  end
end
