defmodule TaksoWeb.BookingController do
  use TaksoWeb, :controller
  import Ecto.Query, only: [from: 2]
  alias Takso.{Repo, Sales.Taxi}

  # We added this function to handle the GET query to "/bookings/new" as
  # specified by the router. If you run "mix phx.routes" you'll see that
  # a GET query to "/bookings/new" get handled by "BookingController"
  # through the method ":new", i.e., this function.
  def new(conn, _params) do
    # Redirect to template "new.html"
    render conn, "new.html"
  end

  # Same than before but handling the query GET to "/bookings" (":index").
  def index(conn, _params) do
    render conn, "index.html"
  end

  def create(conn, _params) do
    # Query the database to retrieve the list of available taxis
    query = from t in Taxi, where: t.status == "available", select: t
    available_taxis = Repo.all(query)
    # If there are available taxis
    if length(available_taxis) > 0 do
      # Redirect informing the taxi is coming
      conn
        |> put_flash(:info, "Your taxi will arrive in 15 minutes.")
        |> redirect(to: ~p"/bookings")
    else
      # Redirect informing there are no taxis
      conn
        |> put_flash(:error, "We are sorry, but there are no taxis available, try again later.")
        |> redirect(to: ~p"/bookings")
    end
  end

end
