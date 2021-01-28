defmodule ContentDock.Repo.Migrations.CreateUsersRoles do
  use Ecto.Migration

  def change do
    create table(:users_roles) do
      add :user_id, references(:users)
      add :role_id, references(:roles)
    end

    create unique_index(:users_roles, [:role_id, :user_id])
  end
end
