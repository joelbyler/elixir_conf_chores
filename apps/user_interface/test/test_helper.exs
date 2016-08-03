ExUnit.start

Mix.Task.run "ecto.create", ~w(-r UserInterface.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r UserInterface.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(UserInterface.Repo)

