defmodule Takso.Sales.Booking do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bookings" do
    field :pickup_address, :string
    field :dropoff_address, :string
    field :status, :string, default: "open"

    belongs_to :user, Takso.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(booking, attrs) do
    booking
    |> cast(attrs, [:pickup_address, :dropoff_address, :status])
    |> validate_required([:pickup_address, :dropoff_address])
    |> validate_different(:pickup_address, :dropoff_address)
  end

  def validate_different(changeset, field_1, field_2) do
    if get_field(changeset, field_1) == get_field(changeset, field_2) do
      changeset
      |> add_error(field_1, "Pickup and dropoff addresses must be different.", [other: field_2])
      |> add_error(field_2, "Pickup and dropoff addresses must be different.", [other: field_1])
    else
      changeset
    end
  end

end
