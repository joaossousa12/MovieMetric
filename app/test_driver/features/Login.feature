Feature: Login
  Scenario: Login failure
    When I write "wrong@gmail.com.com" in "email_field"
    And I write "wrong" in "password_field"
    And I tap the element with the key "login_button"
    And the element with the key "home_page" is present
    And I tap the element with the key "home_page"
    And the element with the key "logout_button" is present
    Then I tap the element with the key "logout_button"

