defmodule ContentDock.Accounts.Role do
  @moduledoc """
  Module for the Role context
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "roles" do
    field :name, :string

    many_to_many :users, ContentDock.Accounts.User, join_through: "users_roles"
  end

  def changeset(role, attrs) do
    role
    |> cast(attrs, [:name])
  end
end
