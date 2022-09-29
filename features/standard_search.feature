Feature: Standard Search

  Scenario: Search from search bar outside advanced search page
    Given I visit the homepage
    When I fill in the search bar form
    And I click the Search button
    Then I should be redirected to the search results page

  Scenario: Search from search bar on advanced search page
    Given I visit the advanced search page
    When I fill in the search bar form
    And I click the Search button
    Then I should be redirected to the search results page
