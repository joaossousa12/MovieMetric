
## Architecture and Design

    MovieMetric consists of four major components: the user interface (UI), the business logic (logic), user authentication, and the database schema. 
    The UI component includes all the screens, forms, and graphical elements that the users interact with. The logic component implements the application's functionality, such as movie rating, commenting, and data validation. 
    The authentication component handles user authentication and authorization, while the database schema stores all the data related to movies, ratings, comments, and users.

    The components are interconnected in a way that the UI communicates with the logic component to retrieve and display data, while the logic component interacts with the database schema to retrieve and store data. 
    The authentication component is responsible for verifying user credentials and authorizing access to specific features of the application. 
    The use of well-known architectural and design patterns can make the implementation and maintenance of this system easier and more efficient.

    One typical problem that may be encountered in the MovieMetric project is managing the state of the application. 
    To solve this problem, we can apply the state design pattern. 
    By keeping track of the state of the application, we can ensure that the different components are in sync and that the user is provided with accurate and up-to-date information.

    In summary, MovieMetric consists of interconnected components that work together to provide the user with an intuitive and efficient experience. 
    By applying well-known architectural and design patterns, we can solve typical problems encountered in the development of this type of application and ensure that the system is easy to maintain and extend.

### Logical architecture

![image](https://github.com/FEUP-LEIC-ES-2022-23/2LEIC10T5/assets/92685130/deec9b33-5211-44b3-ba17-08c972996f9b)


**MovieMetric UI**: 

    This package contains all the user interface components. 
    It includes various screens, forms, buttons, and other graphical elements that the users interact with while using the app.
    
**MovieMetric Logic**: 

    This package contains the business logic. 
    It includes all the classes that implement the application's functionality, such as movie rating, commenting, user authentication, and data validation.
    The package also includes the data access objects that interact with the database schema to retrieve and store data.
    
**MovieMetric Authentication**: 

    This package contains the classes and components responsible for authenticating and authorizing users in the MovieMetric application.

**MovieMetric Database Schema**: 

    This package contains the schema and data model for the application's database. 
    It includes all the tables, views, and relationships between the different entities such as movies, users, ratings, comments, etc.
    
**IMDb Database Schema**: 

    This package contains the schema and data model for the IMDb external database. 
    It includes all the tables, views, and relationships between the different entities such as movies, actors, directors, etc. 
    The package also includes the scripts and procedures for accessing and querying the IMDb database from the application.

**Firebase**

    This package is essential for the app, providing authentication and real-time database management. 
    With Firebase Authentication and real-time Database, users can securely store and sync data across multiple devices in real-time. 
    

### Physical architecture

   The physical architecture of the MovieMetric app, represented in UML, consists of various hardware and software components that work together to deliver a seamless experience for users to browse, rate, and discuss movies.

![image](https://github.com/FEUP-LEIC-ES-2022-23/2LEIC10T5/assets/92685130/e5e8d62b-3c8c-4000-b1a2-a79265bf3df2)

Node/Artifact description:

**User client machine (Android)**

    This is the physical device used by the end user to access the system.
    It runs an Android operating system and has a mobile app (built with Flutter) installed on it.
    The app allows the user to view and interact with movie information, ratings, and reviews.
    Local Database (SQLite): This is the local database component of the system, running on the user's client machine (Android).
                             It stores frequently accessed movie information and metadata for offline access and improved performance.
                             The mobile app interacts with the local database to retrieve and store movie data, reducing latency and network calls.
                             SQLite is lightweight and ideal for local storage on mobile devices.
                
    
**Application server**

    This is the server component that represents the back-end component of the app.
    It receives requests from the user's mobile app and connects to the necessary back-end components to fulfill those requests.
    It has a Server API that exposes the system's functionality to the client-side application.
    It is connected to two different back-end components:
        Movie rating/review logic: This component handles user ratings and reviews for movies. It is connected to a rating/review database, where the ratings and reviews are stored.
        Movie information logic: This component handles movie information and metadata. It connects to the IMDb API and obtains the information on the database. 
        Rating/Review Database and Authentication (Firebase): This is the remote database component of the system, powered by Firebase.
                                                              It stores user-generated movie ratings and reviews.
                                                              The movie rating/review logic component connects to this database to store and retrieve rating and review data.
                                                              Firebase provides real-time synchronization, scalability, and ease of integration with the mobile app.

**IMDB server**

    This is an external server that is not part of the system, but is connected to by the movie information logic component.
    It runs an API that allows the movie information logic component to obtain data from the IMDB database.
    The IMDB database contains a vast amount of information about movies, including cast and crew information, plot summaries, and user ratings.


### Vertical prototype

When the user launches the app, they are presented with a Home page that displays a welcoming message and two buttons. One button leads to a Credits page, which lists the names of the app's creators. The other button leads to the user's Favorite Movies page, which displays all their favorite movies.

All pages include a Home button (in the form of a home icon at the top right) that allows the user to return to the homepage at any time. The app also features Login and Register buttons, which take the user to the login and signup pages. The user's credentials are stored securely using Firebase Authentication, and the app checks them at login to ensure secure access.

![image](https://user-images.githubusercontent.com/92685130/227719366-e5db296d-cce0-4909-afc6-f67ed8a2a39c.png)

![image](https://user-images.githubusercontent.com/92685130/227719380-7180bc73-2f07-4b04-af95-d536c12568cf.png)

![image](https://user-images.githubusercontent.com/92685130/227719395-91f0516b-c862-4408-8de9-c4173764fb98.png)

![image](https://user-images.githubusercontent.com/92685130/227719406-2aa6fb54-45ff-4d6c-bedd-cf6502161b17.png)

![image](https://user-images.githubusercontent.com/92685130/227719428-bf17f3e7-2def-41e6-a8ea-fbd66022c5f6.png)




