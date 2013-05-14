Feature: Administrator lists users

  As an administrator of the system
  I would like to view all users in the system
  So that I know who is registered

  Scenario: successfully viewing users

    Given I am logged in as an administrator
    And there are several users configured
    When I visit the home page
    Then I should be able to visit the users page
    When I visit the users page
    Then I should see all users within the system

  Scenario: searching for users

    Given I am logged in as an administrator
    And there are several users configured
    When I visit the users page
    And I search for a user
    Then I should see only matching users

  Scenario: viewing users when not logged in

    Given I am not logged in
    When I visit the users page
    Then I should see a message stating that I do not have permission to view that page

  Scenario: viewing users when not logged in as an administrator

    Given I am logged in as a non-administrator
    When I visit the users page
    Then I should see a message stating that I do not have permission to view that page
