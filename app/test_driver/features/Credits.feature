Feature: Credits page
  the user should be able to see the credits page

  Scenario: Credits page acessible
    When I write "test@gmail.com" in "email_field"
    And I write "test123" in "password_field"
    When I tap the element with the key "login_button"
    And I pause for 1 seconds
    Then the element with the key "credits" is present
    When I tap the element with the key "credits"
    And I pause for 1 seconds
    Then the element with the key "logout_button" is present
    And I tap the element with the key "logout_button"