defmodule WhiteBreadContext do
  use WhiteBread.Context
  use Hound.Helpers

  alias Takso.{Repo,Sales.Taxi}

  feature_starting_state fn  ->
    Application.ensure_all_started(:hound)
    %{}
  end

  scenario_starting_state fn _state ->
    Hound.start_session
    Ecto.Adapters.SQL.Sandbox.checkout(Takso.Repo)
    Ecto.Adapters.SQL.Sandbox.mode(Takso.Repo, {:shared, self()})
    %{}
  end

  scenario_finalize fn _status, _state ->
    Ecto.Adapters.SQL.Sandbox.checkin(Takso.Repo)
    # Uncomment this line to automatically close the browser after each scenario
    # Hound.end_session
    nil
  end

  given_ ~r/^the following taxis are on duty$/,
  fn state, %{table_data: table} ->
    # Reads the values specified in the Gherkin feature and adds them to the DB
    table
    |> Enum.map(fn taxi -> Taxi.changeset(%Taxi{}, taxi) end)
    |> Enum.each(fn changeset -> Repo.insert!(changeset) end)
    {:ok, state}
  end

  and_ ~r/^I want to go from "(?<pickup_address>[^"]+)" to "(?<dropoff_address>[^"]+)"$/,
  fn state, %{pickup_address: pickup_address, dropoff_address: dropoff_address} ->
    {
      :ok,
      state
      |> Map.put(:pickup_address, pickup_address)
      |> Map.put(:dropoff_address, dropoff_address)
    }
  end

  and_ ~r/^I open STRS' web page$/,
  fn state ->
    navigate_to "/bookings/new"
    {:ok, state}
  end

  and_ ~r/^I enter the booking information$/,
  fn state ->
    fill_field({:id, "booking_pickup_address"}, state[:pickup_address])
    fill_field({:id, "booking_dropoff_address"}, state[:dropoff_address])
    {:ok, state}
  end

  when_ ~r/^I summit the booking request$/,
  fn state ->
    click({:id, "submit_button"})
    {:ok, state}
  end

  then_ ~r/^I should receive a confirmation message$/,
  fn state ->
    assert visible_in_page? ~r/Your taxi will arrive in \d+ minutes/
    {:ok, state}
  end

  then_ ~r/^I should receive an error saying "(?<message>[^"]+)"$/,
  fn state, %{message: message} ->
    # Check that we get the expected message in the page
    assert visible_in_page? ~r/#{message}/
    {:ok, state}
  end
end
