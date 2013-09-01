Feature: Text Import
  In order to onboard the new aquisition
  As a developer
  I want to import their text files to a relational database

  Scenario: Import a text file
    Given I have a tab delimited text file
    And I go to the text importer
    When I upload the text file
    Then I should see the imported purchase total
