defmodule Integration.PipelineTest do
  use HelloSocketsWeb.ChannelCase, async: false
  alias HelloSocketsWeb.AuthSocket
  alias HelloSockets.Pipeline.Producer

  defp connect_auth_socket(user_id) do
    {:ok, _, %Phoenix.Socket{}} =
      socket(AuthSocket, nil, %{user_id: user_id})
      |> subscribe_and_join("user:#{user_id}", %{})
  end

  test "event are pushed from begining to end correctly" do
    connect_auth_socket(1)

    Enum.each(1..2, fn n ->
      Producer.push_timed(%{data: %{n: n}, user_id: 1})
      assert_push "push_timed", %{n: ^n}, 10000
    end)
  end

  test "an event is not delivered to the wrong user" do
    connect_auth_socket(2)
    Producer.push_timed(%{data: %{test: true}, user_id: 1})
    refute_push "push_timed", %{test: true}
  end

  test "events are timed on delivery" do
    self = self()

    :ok = :telemetry.attach(
      "test-telemetry",
      [:hello_sockets, :pipeline],
      fn name, measurements, metadata, _config ->
        send(self, {:telemetry_event, name, measurements, metadata})
      end,
      nil
    )

    connect_auth_socket(1)
    Producer.push_timed(%{data: %{test: true}, user_id: 1})
    assert_push "push_timed", %{test: true}, 10000
    assert_receive {:telemetry_event, [:hello_sockets, :pipeline], %{duration: _value}, %{}}, 2000
  end
end
