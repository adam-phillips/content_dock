defmodule ContentDock.Pages.Blog do
  use Ecto.Schema
  import Ecto.Changeset

  schema "blogs" do
    field :blog_content, :string
    field :description, :string
    field :published_at, :naive_datetime
    field :slug, :string
    field :tags, {:array, :string}
    field :title, :string
    field :author, :id
    field :rendered_html, :string

    timestamps()
  end

  @doc false
  def changeset(blog, attrs) do
    blog
    |> cast(attrs, [:title, :description, :blog_content, :slug, :published_at, :tags, :rendered_html])
    |> validate_required([:title, :description, :blog_content, :slug, :published_at, :tags, :rendered_html])
    |> validate_html()
    |> unique_constraint(:title)
  end

  def validate_html(changeset) do
    case get_field(changeset, :rendered_html) |> IO.inspect() do
      "<p><br></p>" ->
        IO.puts("bad")
        add_error(changeset, :rendered_html, "can't be blank", validation: :required)

      _ ->
        IO.puts("good")
        changeset
    end
    |> IO.inspect()
  end
end
