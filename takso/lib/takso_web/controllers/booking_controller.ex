defmodule TaksoWeb.BookingController do
  use TaksoWeb, :controller
  import Ecto.Query, only: [from: 2]
  alias Takso.{Repo, Sales.Taxi, Sales.Booking}

  # We added this function to handle the GET query to "/bookings/new" as
  # specified by the router. If you run "mix phx.routes" you'll see that
  # a GET query to "/bookings/new" get handled by "BookingController"
  # through the method ":new", i.e., this function.
  def new(conn, _params) do
    # Redirect to template "new.html"
    changeset = Booking.changeset(%Booking{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  # Same than before but handling the query GET to "/bookings" (":index").
  def index(conn, _params) do
    render conn, "index.html"
  end

  def create(conn, %{"booking" => booking_params}) do
    # Create changeset for the booking (to validate)
    changeset = Booking.changeset(%Booking{}, booking_params)
    if changeset.valid? do
      # Valid, query the database to retrieve the list of available taxis
      query = from t in Taxi, where: t.status == "available", select: t
      available_taxis = Repo.all(query)
      # If there are available taxis
      if length(available_taxis) > 0 do
        # Make association and try to insert the booking in the DB
        user = conn.assigns.current_user  # Retrieve the current user from the connection
        IO.inspect(changeset)
        booking_assoc = Ecto.build_assoc(
          user,
          :bookings,
          Enum.map(booking_params, fn({key, value}) -> {String.to_atom(key), value} end)
        )
        IO.inspect(booking_assoc)
        case Repo.insert(booking_assoc) do
          {:ok, _booking} ->
            conn
              |> put_flash(:info, "Your taxi will arrive in 15 minutes.")
              |> redirect(to: ~p"/bookings")
          {:error, %Ecto.Changeset{} = changeset} ->
            render(conn, "new.html", changeset: changeset)
        end
      else
        # Redirect informing there are no taxis
        conn
          |> put_flash(:error, "We are sorry, but there are no taxis available, try again later.")
          |> redirect(to: ~p"/bookings")
      end
    else
      # Invalid, report error
      #   Call to "Repo.insert/1" knowing it is going to fail
      #   only to add the error report in the changeset
      {:error, changeset} = Repo.insert(changeset)
      render(conn, "new.html", changeset: changeset)
    end
  end

end
