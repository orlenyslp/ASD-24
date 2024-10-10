defmodule TaksoWeb.UserController do
  use TaksoWeb, :controller

  alias Takso.{Repo, Accounts.User}

  # Function to go to the index page (where the users are being listed)
  def index(conn, _params) do
    # Retrieve users
    users = Repo.all(User)
    # Render index template (passing the list of existent users)
    render conn, "index.html", users: users
  end

  # Function to go to the Create User page
  def new(conn, _params) do
    # Create empty user changeset (so the page displays empty fields)
    changeset = User.changeset(%User{}, %{})
    # Render the page where to write the user data (passing the empty changeset)
    render(conn, "new.html", changeset: changeset)
  end

  # Function to create a user and redirect to the index
  def create(conn, %{"user" => user_params}) do
    # Create changeset (validate) with the received params
    changeset = User.changeset(%User{}, user_params)
    # Try to insert user in the database
    case Repo.insert(changeset) do
      {:ok, _user} ->
        # Success, inform and redirect to index (not render!)
        conn
          |> put_flash(:info, "User created successfully.")
          |> redirect(to: ~p"/users")
      {:error, %Ecto.Changeset{} = changeset} ->
        # Error, return changeset (that already contains the error)
        render(conn, "new.html", changeset: changeset)
    end
  end

  # Function to go to the Edit User
  def edit(conn, %{"id" => id}) do
    # Retrieve the user data from the database
    user = Repo.get!(User, id)
    changeset = User.changeset(user, %{})
    # Render the page where to update the user data (passing the existing data)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  # Function to update the data of a user and redirect to the index
  def update(conn, %{"id" => id, "user" => user_params}) do
    # Retrieve the data of the user
    user = Repo.get!(User, id)
    # Update the data (in the changeset)
    changeset = User.changeset(user, user_params)
    # Try to update the data in the database
    case Repo.update(changeset) do
      {:ok, _user} ->
        # Success, inform and redirect to index (not render!)
        conn
          |> put_flash(:info, "User updated successfully.")
          |> redirect(to: ~p"/users")
      {:error, %Ecto.Changeset{} = changeset} ->
        # Error, return changeset (that already contains the error)
        render(conn, "edit.html", user: user, changeset: changeset)
    end
    # Assuming success, redirect to index (not render!)
    redirect(conn, to: ~p"/users")
  end

  # Function to go to a page where the data of a user is visualized
  def show(conn, %{"id" => id}) do
    # Retrieve the user data from the database
    user = Repo.get!(User, id)
    # Render the page where to view the user data (passing the existing data)
    render(conn, "show.html", user: user)
  end

  # Function to delete a user from the database and redirect to the index
  def delete(conn, %{"id" => id}) do
    # Retrieve user from the database
    user = Repo.get!(User, id)
    # Delete user from the database
    Repo.delete!(user)
    # Add info and redirect to the index
    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: ~p"/users")
  end

end
