# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ContentDock.Repo.insert!(%ContentDock.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
{:ok, _} =
  ContentDock.Accounts.create_user(%{
    email: "test@test.com",
    first_name: "Test",
    last_name: "User"
  })
