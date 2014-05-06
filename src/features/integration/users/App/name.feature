Feature: Name
    Scenario: Autocomplete
        Given I am on the site
        When I log in
        Then the "name field" should be filled with "TEALS UAG"
