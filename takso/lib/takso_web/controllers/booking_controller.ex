defmodule TaksoWeb.BookingController do
  use TaksoWeb, :controller

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
    conn
      |> put_flash(:info, "Your taxi will arrive in 15 minutes.")
      |> redirect(to: ~p"/bookings")
  end

end
