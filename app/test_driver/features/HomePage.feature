Feature:HomePage
  Scenario: HomePage
    When I write "test@gmail.com" in "email_field"
    When I write "test123" in "password_field"
    When I tap the element with the key "login_button"
    And I pause for 1 seconds
    When I tap the element with the key "home_page"
    Then the element with the key "home_page" is present
    And I pause for 1 seconds
    Then the element with the key "logout_button" is present
    And I tap the element with the key "logout_button"