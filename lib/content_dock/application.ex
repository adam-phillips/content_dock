defmodule ContentDock.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      ContentDock.Repo,
      # Start the Telemetry supervisor
      ContentDockWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: ContentDock.PubSub},
      # Start the Endpoint (http/https)
      ContentDockWeb.Endpoint
      # Start a worker by calling: ContentDock.Worker.start_link(arg)
      # {ContentDock.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ContentDock.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ContentDockWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
