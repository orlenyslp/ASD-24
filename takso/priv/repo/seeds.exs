# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Takso.Repo.insert!(%Takso.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Takso.{Repo, Accounts.User}

[%{name: "Dio Brando", username: "DIO", password: "itsmedio"},
 %{name: "Jotaro Kujo", username: "JoJo", password: "oraoraora"}]
|> Enum.map(fn user_data -> User.changeset(%User{}, user_data) end)
|> Enum.each(fn changeset -> Repo.insert!(changeset) end)
