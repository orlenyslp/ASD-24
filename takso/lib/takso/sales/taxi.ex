defmodule Takso.Sales.Taxi do
  use Ecto.Schema

  import Ecto.Changeset

  schema "taxis" do
    field :username, :string
    field :location, :string
    field :status, :string
    timestamps()
  end

  @doc false
  def changeset(taxi, attrs) do
    taxi
    |> cast(attrs, [:username, :location, :status])
    |> validate_required([:username, :location, :status])
  end

end
