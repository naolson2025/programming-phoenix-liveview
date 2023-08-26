defmodule ProgrammingPhoenixLiveview.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      ProgrammingPhoenixLiveviewWeb.Telemetry,
      # Start the Ecto repository
      ProgrammingPhoenixLiveview.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: ProgrammingPhoenixLiveview.PubSub},
      # Start Finch
      {Finch, name: ProgrammingPhoenixLiveview.Finch},
      ProgrammingPhoenixLiveviewWeb.Presence, # added presence to our app start up
      # Start the Endpoint (http/https)
      ProgrammingPhoenixLiveviewWeb.Endpoint
      # Start a worker by calling: ProgrammingPhoenixLiveview.Worker.start_link(arg)
      # {ProgrammingPhoenixLiveview.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ProgrammingPhoenixLiveview.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ProgrammingPhoenixLiveviewWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
