Feature: Finder

  Scenario: Open the app and open the credits page
    Given the "HomePage" screen
    When I tap "Credits"
    Then I can see "Created by:"

  Scenario: Open the app and see the movies displayed
    Given the "HomePage" screen
    When I tap "trendingMovies"
    Then I can see "Description"
