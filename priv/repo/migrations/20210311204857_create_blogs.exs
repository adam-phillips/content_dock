defmodule ContentDock.Repo.Migrations.CreateBlogs do
  use Ecto.Migration

  def change do
    create table(:blogs) do
      add :title, :string
      add :description, :string
      add :blog_content, :string
      add :rendered_html, :string
      add :slug, :string
      add :published_at, :naive_datetime
      add :tags, {:array, :string}
      add :author, references(:users, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:blogs, [:title])
    create index(:blogs, [:author])
  end
end
