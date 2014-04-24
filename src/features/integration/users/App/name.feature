Feature: Name
    Scenario: Autocomplete
        Given I am on the site
        When I type "Dav" into the "name field"
        Then I should see "David Souther" in the "name autocomplete"
