Feature: Leaderboard
    Scenario: shows leaders
        Given I am on the site
        When I click "top nav"
        Then the "leaderboard" should have several rows
