defmodule HelloSocketsWeb.ChannelCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with channels
      import Phoenix.ChannelTest
      import HelloSocketsWeb.ChannelCase

      # The default endpoint for testing
      @endpoint HelloSocketsWeb.Endpoint
    end
  end

  setup _tags do
    :ok
  end
end
