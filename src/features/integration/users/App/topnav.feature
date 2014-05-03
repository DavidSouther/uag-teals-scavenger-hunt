Feature: Top Nav
    Scenario: links to leaders
        Given I am on the site
        When I log in
        Then the "top nav" should have links
            """
            Leaders
            """
        When I click "top nav"
        Then the "top nav" should have links
            """
            Submit
            """
