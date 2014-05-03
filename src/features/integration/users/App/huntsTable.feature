Feature: Scavenger Hunt List
    Scenario: lists available programs
        Given I am on the site
        When I log in
        Then the "hunt table" should have several rows
