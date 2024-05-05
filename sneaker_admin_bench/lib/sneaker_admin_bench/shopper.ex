defmodule SneakerAdminBench.Shopper do
  @moduledoc """
  Single shopper client orchestration process. You can start up many of these concurrently, but
  your computer may not be able to make all of the outbound connections properly. I find this starts
  to happen around 6000 connections on my computer, but it may differ or not be a problem for you.
  """

  use GenServer
  require Logger

  @socket_opts [
    # This is hardcoded based on our application's defaults
    url: "ws://localhost:4000/product_socket/websocket",
    reconnect_interval: 10_000
  ]

  @connect_tries 200
  @connect_wait 500

  # This is hardcoded based on having a freshly seeded DB
  @max_item_id 26

  def start(opts) do
    GenServer.start(__MODULE__, [opts])
  end

  def init(_) do
    {:ok, %{connect_count: 0}, {:continue, []}}
  end

  def handle_continue([], state) do
    {:ok, socket} = PhoenixClient.Socket.start_link(@socket_opts)
    send(self(), :connect_channel)
    {:noreply, Map.put(state, :socket, socket)}
  end

  def handle_info(:connect_channel, %{connect_count: count}) when count > @connect_tries do
    Logger.error("Channel connection failed after #{@connect_tries * @connect_wait}ms")
    {:stop, :connect_timeout}
  end

  def handle_info(:connect_channel, state = %{socket: socket, connect_count: count}) do
    if PhoenixClient.Socket.connected?(socket) do
      {:ok, _response, channel} = PhoenixClient.Channel.join(
        socket,
        "cart:#{generate_cart_id()}",
        %{page: "/bench/#{:rand.uniform(4)}"}
      )

      state = Map.put(state, :channel, channel)

      {:ok, _message} = PhoenixClient.Channel.push(
        channel, "add_item", %{item_id: random_item_id()}
      )

      {:noreply, state}
    else
      Process.send_after(self(), :connect_channel, @connect_wait)
      {:noreply, %{state | connect_count: count + 1}}
    end
  end

  def handle_info(%{event: "cart"}, state) do
    {:noreply, state}
  end

  @cart_id_length 64
  defp generate_cart_id() do
    :crypto.strong_rand_bytes(@cart_id_length)
    |> Base.encode64()
    |> binary_part(0, @cart_id_length)
  end

  defp random_item_id(), do: to_string(:rand.uniform(@max_item_id))
end
