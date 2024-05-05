defmodule Sneakers23.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Sneakers23Web.Telemetry,
      Sneakers23.Repo,
      {DNSCluster, query: Application.get_env(:sneakers_23, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Sneakers23.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Sneakers23.Finch},
      # Start a worker by calling: Sneakers23.Worker.start_link(arg)
      # {Sneakers23.Worker, arg},
      # Start to serve requests, typically the last entry
      Sneakers23Web.Endpoint,
      Sneakers23.Inventory,
      Sneakers23.Replication,
      {Sneakers23Web.CartTracker, [pool_size: :erlang.system_info(:schedulers_online)]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Sneakers23.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    Sneakers23Web.Endpoint.config_change(changed, removed)
    :ok
  end
end
