# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     UserInterface.Repo.insert!(%UserInterface.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias UserInterface.Repo
alias UserInterface.Chore

Repo.insert! %Chore{
  name: "Attend Joel's Talk",
  order: 1,
  description: "I think you'll enjoy it.",
  bonus: false
}

Repo.insert! %Chore{
  name: "Tweet at Joel and/or ElixirConf",
  order: 2,
  description: "His twittler account is @joelbyler",
  bonus: true
}

Repo.insert! %Chore{
  name: "Complement your neighbor",
  order: 3,
  description: "Its good to make friends",
  bonus: false
}
