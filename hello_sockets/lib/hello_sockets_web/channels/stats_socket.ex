defmodule HelloSocketsWeb.StatsSocket do
  use Phoenix.Socket
  channel "*", HelloSocketsWeb.StatsChannel

  def connect(_params, socket, _connect_info) do
    :telemetry.execute(
      [:hello_sockets, :socket],
      %{socket_connect: 1},
      %{status: "success", socket: __MODULE__}
    )

    {:ok, socket}
  end

  def id(_socket), do: nil
end
