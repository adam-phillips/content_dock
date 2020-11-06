defmodule ContentDock.Repo do
  use Ecto.Repo,
    otp_app: :content_dock,
    adapter: Ecto.Adapters.Postgres
end
