defmodule WhiteBreadContext do
  use WhiteBread.Context
  use Hound.Helpers

  feature_starting_state fn  ->
    Application.ensure_all_started(:hound)
    %{}
  end

  scenario_starting_state fn _state ->
    Hound.start_session
    %{}
  end

  scenario_finalize fn _status, _state ->
    # Uncomment this line to automatically close the browser after each scenario
    # Hound.end_session
    nil
  end

  given_ ~r/^the following taxis are on duty$/,
  fn state ->
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
    fill_field({:id, "pickup_address"}, state[:pickup_address])
    fill_field({:id, "dropoff_address"}, state[:dropoff_address])
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
end
