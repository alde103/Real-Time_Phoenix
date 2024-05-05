defmodule SneakerAdminBench do
  @moduledoc """
  Starts many Shopper connections. Each connection will join a unique CartChannel and
  add a random item.
  """

  def start_connections(chunks \\ 10) when chunks > 0 and chunks <= 50 do
    Enum.each(1..chunks, fn _ ->
      Enum.each(1..100, fn _ -> SneakerAdminBench.Shopper.start([]) end)
      Process.sleep(100)
    end)
  end
end
