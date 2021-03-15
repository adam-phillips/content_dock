defmodule ContentDock.PagesTest do
  use ContentDock.DataCase

  alias ContentDock.Pages

  describe "blogs" do
    alias ContentDock.Pages.Blog

    @valid_attrs %{blog_content: "some blog_content", description: "some description", published_at: ~N[2010-04-17 14:00:00], slug: "some slug", tags: [], title: "some title"}
    @update_attrs %{blog_content: "some updated blog_content", description: "some updated description", published_at: ~N[2011-05-18 15:01:01], slug: "some updated slug", tags: [], title: "some updated title"}
    @invalid_attrs %{blog_content: nil, description: nil, published_at: nil, slug: nil, tags: nil, title: nil}

    def blog_fixture(attrs \\ %{}) do
      {:ok, blog} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Pages.create_blog()

      blog
    end

    test "list_blogs/0 returns all blogs" do
      blog = blog_fixture()
      assert Pages.list_blogs() == [blog]
    end

    test "get_blog!/1 returns the blog with given id" do
      blog = blog_fixture()
      assert Pages.get_blog!(blog.id) == blog
    end

    test "create_blog/1 with valid data creates a blog" do
      assert {:ok, %Blog{} = blog} = Pages.create_blog(@valid_attrs)
      assert blog.blog_content == "some blog_content"
      assert blog.description == "some description"
      assert blog.published_at == ~N[2010-04-17 14:00:00]
      assert blog.slug == "some slug"
      assert blog.tags == []
      assert blog.title == "some title"
    end

    test "create_blog/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Pages.create_blog(@invalid_attrs)
    end

    test "update_blog/2 with valid data updates the blog" do
      blog = blog_fixture()
      assert {:ok, %Blog{} = blog} = Pages.update_blog(blog, @update_attrs)
      assert blog.blog_content == "some updated blog_content"
      assert blog.description == "some updated description"
      assert blog.published_at == ~N[2011-05-18 15:01:01]
      assert blog.slug == "some updated slug"
      assert blog.tags == []
      assert blog.title == "some updated title"
    end

    test "update_blog/2 with invalid data returns error changeset" do
      blog = blog_fixture()
      assert {:error, %Ecto.Changeset{}} = Pages.update_blog(blog, @invalid_attrs)
      assert blog == Pages.get_blog!(blog.id)
    end

    test "delete_blog/1 deletes the blog" do
      blog = blog_fixture()
      assert {:ok, %Blog{}} = Pages.delete_blog(blog)
      assert_raise Ecto.NoResultsError, fn -> Pages.get_blog!(blog.id) end
    end

    test "change_blog/1 returns a blog changeset" do
      blog = blog_fixture()
      assert %Ecto.Changeset{} = Pages.change_blog(blog)
    end
  end
end
