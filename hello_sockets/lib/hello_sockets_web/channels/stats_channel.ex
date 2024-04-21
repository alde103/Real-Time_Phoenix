defmodule HelloSocketsWeb.StatsChannel do
  use Phoenix.Channel

  def join("valid", _payload, socket) do
    channel_join_increment("success")
    {:ok, socket}
  end

  def join("invalid", _payload, _socket) do
    channel_join_increment("fail")
    {:error, %{reason: "always fails"}}
  end

  defp channel_join_increment(status) do
    :telemetry.execute(
      [:hello_sockets, :channel],
      %{channel_join: 1},
      %{status: status, channel: __MODULE__}
    )
  end

  def handle_in("ping", _payload, socket) do
    start_time = System.monotonic_time()

    Process.sleep(:rand.uniform(1000))

    duration = System.monotonic_time() - start_time

    :telemetry.execute(
      [:hello_sockets, :stats_channel, :ping],
      %{duration: duration},
      %{}
    )

    {:reply, {:ok, %{ping: "pong"}}, socket}
  end

  def handle_in("slow_ping", _payload, socket) do
    Process.sleep(1000)
    {:reply, {:ok, %{ping: "pong"}}, socket}
  end

  def handle_in("parallel_slow_ping", _payload, socket) do
    ref = socket_ref(socket)

    Task.start_link(fn ->
      Process.sleep(2000)
      Phoenix.Channel.reply(ref, {:ok, %{ping: "pong"}})
    end)

    {:noreply, socket}
  end
end
