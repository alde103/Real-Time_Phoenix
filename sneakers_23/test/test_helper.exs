Application.ensure_all_started(:hound)
ExUnit.start()
:sys.get_state(Sneakers23.Inventory)
Ecto.Adapters.SQL.Sandbox.mode(Sneakers23.Repo, :manual)
