defmodule Acceptance.HomePageTest do
  use ExUnit.Case, async: false
  use Hound.Helpers

  # Run chromedriver-linux64/chromedriver --verbose

  setup do
    ua = "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36"
    Hound.start_session(additional_capabilities: %{chromeOptions: %{"args" => ["--user-agent=#{ua}", "--headless", "--disable-gpu"], "binary" => "/usr/bin/google-chrome"}})
    :ok
  end

  test "the page loads" do
    navigate_to("http://127.0.0.1:4002")
    assert page_title() =~ "Sneakers23"
  end
end
