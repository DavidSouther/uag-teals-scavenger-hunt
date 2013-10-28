Feature: Base App

    Scenario: Smooooke in the Browser
        Given smoke has a browser open
        When it goes to the site directly
        Then it should see "Angular Base App" in the title bar
