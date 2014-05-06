Feature: Scavenger Hunt List
    Scenario: lists available programs
        Given I am on the site
        When I log in
        And I toggle the "Intro" hunt
        Then the "hunt table" should have several rows
