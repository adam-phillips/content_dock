defmodule ContentDockWeb.BlogLive.Index do
  use ContentDockWeb, :live_view

  alias ContentDock.Pages
  alias ContentDock.Pages.Blog

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :blogs, list_blogs())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Blog")
    |> assign(:blog, Pages.get_blog!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Blog")
    |> assign(:blog, %Blog{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Blogs")
    |> assign(:blog, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    blog = Pages.get_blog!(id)
    {:ok, _} = Pages.delete_blog(blog)

    {:noreply, assign(socket, :blogs, list_blogs())}
  end

  defp list_blogs do
    Pages.list_blogs()
  end
end
