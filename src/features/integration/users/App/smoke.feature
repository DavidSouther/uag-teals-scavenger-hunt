Feature: Base App

    Scenario: Smooooke in the Browser
        Given smoke has a browser open
        When it goes to the site directly
        Then it should see "TEALS" in the title bar
