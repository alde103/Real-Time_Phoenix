defmodule ReactExample.Repo do
  use Ecto.Repo,
    otp_app: :react_example,
    adapter: Ecto.Adapters.Postgres
end
