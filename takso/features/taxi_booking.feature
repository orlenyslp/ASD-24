Feature: Taxi booking
  As a customer
  Such that I go to destination
  I want to arrange a taxi ride

  Scenario: Booking via STRS' web page (with confirmation)
    Given the following taxis are on duty
          | username  | location      | status    |
          | trafalgar | Juhan Liivi 2 | busy      |
          | mihawk    | Kalevi 4      | available |
    And I want to go from "Juhan Liivi 2" to "Muuseumi tee 2"
    And I open STRS' web page
    And I enter the booking information
    When I summit the booking request
    Then I should receive a confirmation message
