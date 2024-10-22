defmodule TaksoWeb.SessionController do
  use TaksoWeb, :controller

  import Takso.Authentication, only: [check_credentials: 4]

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, %{"username" => username, "password" => password}) do
    case check_credentials(conn, username, password, repo: Takso.Repo) do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "Welcome #{username}")
        |> redirect(to: ~p"/users")
      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Bad credentials")
        |> render("new.html")
    end
  end

end
