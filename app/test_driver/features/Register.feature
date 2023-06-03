Scenario: Registration successful
  When I write "eu@gmail.com.com" in "email_field"
  And I write "123456" in "password_field"
  And I write "123456" in "confirmPassword_field"
  And I tap the element with the key "signUp_button"