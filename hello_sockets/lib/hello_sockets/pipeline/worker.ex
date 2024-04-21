defmodule HelloSockets.Pipeline.Worker do
  alias HelloSockets.Pipeline.Timing

  def start_link(item) do
    Task.start_link(fn ->
      start_time = Timing.unix_ms_now()

      process(item)

      duration = Timing.unix_ms_now() - start_time

      :telemetry.execute(
        [:hello_sockets, :pipeline, :consumer],
        %{duration: duration},
        %{}
      )
    end)
  end

  defp process(%{
         item: %{data: data, user_id: user_id},
         enqueued_at: unix_ms
       }) do
    virtual_process(data)

    HelloSocketsWeb.Endpoint.broadcast!("user:#{user_id}", "push_timed", %{
      data: data,
      at: unix_ms
    })
  end

  defp process(%{item: %{data: data, user_id: user_id}}) do
    HelloSocketsWeb.Endpoint.broadcast!("user:#{user_id}", "push", data)
    new_data = virtual_process(data)
    HelloSocketsWeb.Endpoint.broadcast!("user:#{user_id}", "push", new_data)
  end

  defp process(item) do
    IO.inspect(item)
    Process.sleep(10000)
  end

  defp virtual_process(data) do
    duration = :rand.uniform(10000)
    Process.sleep(duration)
    Map.put(data, :duration, duration)
  end
end
