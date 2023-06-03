Scenario: Adding a movie to the favorite's page
  When I write "test@gmail.com" in "email_field"
  When I write "test123" in "password_field"
  When I tap the element with the key "login_button"
  And I pause for 1 seconds
  When I tap the element with the key "movie"
  Then the element with key "favorite" is present
  When I tap the element with the key "favorite_button"
  Then d