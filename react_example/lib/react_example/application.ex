defmodule ReactExample.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ReactExampleWeb.Telemetry,
      ReactExample.Repo,
      {DNSCluster, query: Application.get_env(:react_example, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ReactExample.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: ReactExample.Finch},
      # Start a worker by calling: ReactExample.Worker.start_link(arg)
      # {ReactExample.Worker, arg},
      # Start to serve requests, typically the last entry
      ReactExampleWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ReactExample.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ReactExampleWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
