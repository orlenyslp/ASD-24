defmodule Takso.BookingControllerTest do
  use TaksoWeb.ConnCase

  alias Takso.{Repo,Sales.Taxi,Sales.Booking}

  test "Booking aceptance", %{conn: conn} do
    Repo.insert!(%Taxi{status: "available"})
    conn = post conn, "/bookings", %{booking: [pickup_address: "Liivi 2", dropoff_address: "Lõunakeskus"]}
    conn = get conn, redirected_to(conn)
    assert html_response(conn, 200) =~ ~r/Your taxi will arrive in \d+ minutes/
  end

  test "Booking rejection (no available taxis)", %{conn: conn} do
    Repo.insert!(%Taxi{status: "busy"})
    conn = post conn, "/bookings", %{booking: [pickup_address: "Liivi 2", dropoff_address: "Lõunakeskus"]}
    conn = get conn, redirected_to(conn)
    assert html_response(conn, 200) =~ ~r/We are sorry, but there are no taxis available, try again later./
  end

  test "Booking requires a 'pickup address'" do
    changeset = Booking.changeset(%Booking{}, %{pickup_address: nil, dropoff_address: "Liivi 2"})
    assert Keyword.has_key? changeset.errors, :pickup_address
  end

  test "Booking requires different addresses" do
    changeset = Booking.changeset(%Booking{}, %{pickup_address: "Liivi 2", dropoff_address: "Liivi 2"})
    assert Keyword.has_key? changeset.errors, :pickup_address
    assert Keyword.has_key? changeset.errors, :dropoff_address
  end

end
