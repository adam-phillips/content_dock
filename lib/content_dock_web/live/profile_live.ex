defmodule ContentDockWeb.ProfileLive do
  use ContentDockWeb, :live_view

  alias ContentDock.Accounts
  alias ContentDock.Accounts.User

  @impl true
  def mount(_params, session, socket) do
    socket = assign_session(socket, session)
    socket = assign(socket, :changeset, Accounts.change_user(socket.assigns.current_user))

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", %{"user" => user}, socket) do
    changeset =
      socket.assigns.current_user
      |> Accounts.change_user(user)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    user = socket.assigns.current_user

    socket = case Accounts.update_user(user, user_params) do
      {:ok, %User{} = updated_user} ->
         socket
         |> assign(current_user: updated_user)
         |> put_flash(:info, "User profile was updated!")

      {:error, %Ecto.Changeset{} = changeset} ->
        assign(socket, changeset: changeset)
    end
    {:noreply, socket}
  end
end
