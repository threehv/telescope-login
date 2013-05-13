Feature: user logs in and logs out

  As a user of the system 
  I would like to log in and out again
  So that I can access my stuff

  Scenario: Logging in
    Given that I have a user account
    When I visit the login page
    And I log in 
    Then I should be logged in as expected

  Scenario: Logging in with invalid details
    Given that I have a user account
    When I visit the login page
    And I log in with incorrect details
    Then I should not be logged in
    And I should be offered the chance of logging in again

  Scenario: logging out
    Given that I have a user account
    And I have already logged in
    When I visit the login page
    And I choose to log out
    Then I should be logged out

