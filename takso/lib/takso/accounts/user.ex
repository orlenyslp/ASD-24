defmodule Takso.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :username, :string
    field :password, :string
    field :age, :integer

    has_many :bookings, Takso.Sales.Booking

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :username, :password, :age])
    |> validate_required([:name, :username, :password, :age])
    |> validate_inclusion(:age, 1..150, message: "Age must be between 1 and 150.")
  end
end
