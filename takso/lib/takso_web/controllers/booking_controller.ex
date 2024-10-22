defmodule TaksoWeb.BookingController do
  use TaksoWeb, :controller
  import Ecto.Query, only: [from: 2]
  alias Takso.{Repo}
  alias Takso.Sales.{Taxi, Booking, Allocation}
  alias Ecto.{Changeset, Multi}

  # We added this function to handle the GET query to "/bookings/new" as
  # specified by the router. If you run "mix phx.routes" you'll see that
  # a GET query to "/bookings/new" get handled by "BookingController"
  # through the method ":new", i.e., this function.
  def new(conn, _params) do
    # Redirect to template "new.html"
    changeset = Booking.changeset(%Booking{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def index(conn, _params) do
    user_id = conn.assigns.current_user.id
    bookings = Repo.all(from b in Booking, where: b.user_id == ^user_id)
    render conn, "index.html", bookings: bookings
  end

  def create(conn, %{"booking" => booking_params}) do
    # Retrieve logged user (we assume there is one)
    user = conn.assigns.current_user
    # Build the association (with user) for the booking
    booking_assoc =
      Ecto.build_assoc(
        user,
        :bookings,
        Enum.map(booking_params, fn {key, value} -> {String.to_atom(key), value} end)
      )

    # Update state of the booking to "open"
    booking_changeset =
      Booking.changeset(booking_assoc, %{})
      |> Changeset.put_change(:status, "open")

    # Insert booking un the database
    case Repo.insert(booking_changeset) do
      {:ok, booking} ->
        # Success, query the database to retrieve the list of available taxis
        query = from(t in Taxi, where: t.status == "available", select: t)
        available_taxis = Repo.all(query)
        # If there are available taxis
        if length(available_taxis) > 0 do
          # Retrieve first taxi available
          taxi = List.first(available_taxis)
          # Update database and corresponding statuses
          Multi.new()
          |> Multi.insert(
            :allocation,
            Allocation.changeset(%Allocation{}, %{status: "accepted"})
            |> Changeset.put_change(:booking_id, booking.id)
            |> Changeset.put_change(:taxi_id, taxi.id)
          )
          |> Multi.update(
            :taxi,
            Taxi.changeset(taxi, %{})
            |> Changeset.put_change(:status, "busy")
          )
          |> Multi.update(
            :booking,
            Booking.changeset(booking, %{})
            |> Changeset.put_change(:status, "allocated")
          )
          |> Repo.transaction()

          # Redirect with success message
          conn
          |> put_flash(:info, "Your taxi will arrive in 15 minutes.")
          |> redirect(to: ~p"/bookings")
        else
          # Update state of the booking to "rejected"
          Booking.changeset(booking, %{})
          |> Changeset.put_change(:status, "rejected")
          |> Repo.update()

          # Redirect informing there are no taxis
          conn
          |> put_flash(:error, "We are sorry, but there are no taxis available, try again later.")
          |> redirect(to: ~p"/bookings")
        end

      {:error, %Ecto.Changeset{} = changeset} ->
        # Error trying to insert booking, report
        render(conn, "new.html", changeset: changeset)
    end
  end

  def summary(conn, _params) do
    # JOIN query with alias for the columns
    query =
      from(t in Taxi,
        join: a in Allocation,
        on: t.id == a.taxi_id,
        group_by: t.username,
        where: a.status == "accepted",
        select: %{driver: t.username, num_trips: count(a.id)}
      )
    summary = Repo.all(query)
    # Redirect to the summary page
    render(conn, "summary.html", summary_rows: summary)
  end

end
