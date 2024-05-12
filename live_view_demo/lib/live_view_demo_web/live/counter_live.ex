defmodule LiveViewDemoWeb.CounterLive do
  use LiveViewDemoWeb, :live_view

  def render(assigns) do
    ~H"""
    Current count: <%= @count %>

    <.button phx-click="dec">-</.button>

    <.button phx-click="inc">+</.button>
    """
  end

  def mount(%{"count" => initial}, _session, socket) do
    {:ok, assign(socket, :count, String.to_integer(initial))}
  end

  def mount(_parameters, _session, socket) do
    {:ok, assign(socket, :count, :rand.uniform(100_000))}
  end

  def handle_event("dec", _value, socket) do
    {:noreply, update(socket, :count, &(&1 - 1))}
  end

  def handle_event("inc", _value, socket) do
    {:noreply, update(socket, :count, &(&1 + 1))}
  end
end
