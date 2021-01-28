defmodule ContentDock.Accounts.User do
  @moduledoc """
  Module for the User context
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string

    many_to_many :roles, ContentDock.Accounts.User, join_through: "users_roles"

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :first_name, :last_name])
    |> validate_required([:email, :first_name, :last_name])
  end
end
