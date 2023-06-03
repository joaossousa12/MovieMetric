
## Requirements

### Domain model

To better understand the context of the software system, we created a simple UML class diagram with all the key concepts (names, attributes) and relationships involved of the problem domain addressed by our module. 

![uml](https://user-images.githubusercontent.com/92685130/227724312-3712ae39-1932-4a4b-a923-ad103a96269f.png)


**Registered-User**

  The Registered-User class represents users who have created an account on the platform. 
  These users have provided their login and password information, allowing them to access exclusive features, such as creating movie ratings, managing their favorite movie lists, and leaving comments on movie profiles. 
  Registered-User inherits the properties and methods of the User class.

**Unregistered-User**

  The Unregistered-User class represents users who have not created an account on the platform. 
  They can browse and explore the platform's content, but they cannot access certain features reserved for registered users, such as rating movies, curating favorite movie lists, and commenting on movie profiles. 
  Unregistered-User also inherits from the User class.


**User**

  The User class serves as the base class for Registered-User and Unregistered-User classes. 
  This class contains common attributes, such as login and password fields, which are used to authenticate and distinguish between registered and unregistered users.
  
**Movie Rating**

  The Movie Rating class represents individual movie ratings submitted by registered users. This class contains the rate attribute, which stores the user's rating (scale of 1-5) and the date attribute, which records the date when the rating was submitted. Movie Rating is associated with the User and Movie classes.

**Favorite List**

  The Favorite List class represents a collection of movies curated by a registered user as their favorites. 
  This class contains the movies field, which stores a list of Movies added by the user to their favorites. 
  The Favorite List is associated with the User and Movie classes, as it is created and managed by individual users and consists of movies available on the platform.
  
**Comment**

  The Comment class represents user comments on movies. 
  This class contains the like and dislike attributes, which counts the number of likes and dislikes a comment has received from other users, the date attribute, which records when the comment was posted, and the owner attribute, which identifies the registered user who authored the comment. 
  The Comment class is associated with the User and Movie classes, as comments are created by registered users and linked to specific movies.

**Movie**

  The Movie class serves as the central entity of this domain model, representing individual movies available on the platform. 
  This class contains the name attribute, which stores the title of the movie; the category attribute, which classifies the movie into a specific genre or category; and the actors attribute, which lists the main cast members involved in the production. 
  The Movie class is connected to the Movie Rating, Favorite List, and Comment classes, as users can rate, add to their favorites, and comment on movies, respectively.
