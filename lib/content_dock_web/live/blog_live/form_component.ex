defmodule ContentDockWeb.BlogLive.FormComponent do
  use ContentDockWeb, :live_component

  alias ContentDock.Pages

  @impl true
  def update(%{blog: blog} = assigns, socket) do
    changeset = Pages.change_blog(blog)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"blog" => blog_params}, socket) do
    changeset =
      socket.assigns.blog
      |> Pages.change_blog(blog_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"blog" => blog_params}, socket) do
    save_blog(socket, socket.assigns.action, blog_params)
  end

  defp save_blog(socket, :edit, blog_params) do
    case Pages.update_blog(socket.assigns.blog, blog_params) do
      {:ok, _blog} ->
        {:noreply,
         socket
         |> put_flash(:info, "Blog updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_blog(socket, :new, blog_params) do
    case Pages.create_blog(blog_params) do
      {:ok, _blog} ->
        {:noreply,
         socket
         |> put_flash(:info, "Blog created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
