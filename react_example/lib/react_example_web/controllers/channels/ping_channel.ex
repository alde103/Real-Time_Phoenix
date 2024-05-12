defmodule ReactExampleWeb.PingChannel do
  use Phoenix.Channel

  @topics ["ping", "other"]

  def join(topic, _params, socket) when topic in @topics do
    send(self(), :send_ping)

    {:ok, socket}
  end

  def handle_in("ping", %{}, socket) do
    {:reply, {:ok, %{pong: "true"}}, socket}
  end

  def handle_info(:send_ping, socket) do
    push(socket, "ping", %{
      message: "ping",
      random: :rand.uniform(100_000),
      node: Node.self()
    })

    schedule()

    {:noreply, socket}
  end

  defp schedule() do
    Process.send_after(self(), :send_ping, 2_000)
  end
end
