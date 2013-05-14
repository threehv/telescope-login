Feature: Administrator manages users

  As an administrator of the system
  I would like to manage the users in the system
  So that I can deal with any issues

  Background:
    Given I am logged in as an administrator
    And there are several users configured

  Scenario: adding a new user
    When I visit the users page
    And I choose to add a user
    And I enter their username, password and email
    Then the user should be added

  Scenario: unsuccessfully adding a new user
    When I visit the users page
    And I choose to add a user
    And I enter incorrect details
    Then I should see an error message
    And the user should not be added

  Scenario: editing an existing user
    When I visit the users page
    And I choose to edit a user
    And I update their username and email
    Then the user should be updated

  Scenario: updating an existing users password
    When I visit the users page
    And I choose to edit a user
    And I choose to change the user's password
    Then the user password should be updated

  Scenario: unsuccessfully updating an existing user's password
    When I visit the users page
    And I choose to edit a user
    And I change the user's password incorrectly
    Then the user password should not be updated
    And I should see an error message

  Scenario: removing an existing user
    When I visit the users page
    And I choose to delete a user
    When I confirm the deletion
    Then the user should be deleted
