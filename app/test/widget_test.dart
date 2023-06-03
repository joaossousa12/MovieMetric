
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_metric/description.dart';
import 'package:movie_metric/main.dart';
import 'firebase_mock.dart';
import 'homepage_mock.dart';
import 'package:network_image_mock/network_image_mock.dart';




void main() {
  setupFirebaseAuthMocks();
  group('MovieDescription', () {
    // Initialize test variables
    late String name;
    late String description;
    late String bannerUrl;
    late String posterUrl;
    late String vote;
    late String launchOn;
    late bool isFavorite;

    setUpAll(() async{
      await Firebase.initializeApp();
    });

    setUp(() async {
      // Set up the test variables
      name = 'Movie Name';
      description = 'Movie Description';
      bannerUrl = 'https://picsum.photos/200/300';
      posterUrl = 'https://picsum.photos/200/300';
      vote = '9.8';
      launchOn = '2023-01-01';
      isFavorite = true;
    });

    testWidgets('renders correctly', (WidgetTester tester) async {


      await mockNetworkImagesFor(() => tester.pumpWidget(MaterialApp(
        home: MovieDescription(
          name: name,
          description: description,
          bannerurl: bannerUrl,
          posterurl: posterUrl,
          vote: vote,
          launchOn: launchOn,
          isFavorite: isFavorite,
        ),
      ),
      ));

      expect(find.text(name), findsOneWidget);
      expect(find.text(description), findsOneWidget);
      expect(find.byType(Image), findsNWidgets(4));
    });
    /*
    testWidgets('displays review section', (WidgetTester tester) async {
      await mockNetworkImagesFor(() => tester.pumpWidget(MaterialApp(
        home: MovieDescription(
          name: name,
          description: description,
          bannerurl: bannerUrl,
          posterurl: posterUrl,
          vote: vote,
          launchOn: launchOn,
          isFavorite: isFavorite,
        ),
      ),
      ));

      // Add your assertions here to verify the review section
      // For example:
      expect(find.text('Add your review:'), findsOneWidget);
      expect(find.byType(Slider), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });*/
    test("Review constructor test",() {
      Review set = Review(comment: "a", rating: 0.5);
      expect(set.comment, "a");
      expect(set.rating, 0.5);
    });
    test("MovieDescription constructor test",() {
      MovieDescription set = MovieDescription(
        name: name,
        description: description,
        bannerurl: bannerUrl,
        posterurl: posterUrl,
        vote: vote,
        launchOn: launchOn,
        isFavorite: isFavorite,
      );
      expect(set.name, 'Movie Name');
      expect(set.description, 'Movie Description');
      expect(set.bannerurl, 'https://picsum.photos/200/300');
      expect(set.posterurl, 'https://picsum.photos/200/300');
      expect(set.vote, '9.8');
      expect(set.launchOn, '2023-01-01');
      expect(set.isFavorite, true);
    });
  });
  group('HomePage tests', ()
  {
    setUpAll(() async{
      await Firebase.initializeApp();
    });

    testWidgets('Open Sign-up', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: CustomAppBar(
          title: "title",
          isLoggedIn: false))); // Assuming MyApp contains the SignUpPage widget
      final signUpPage = find.byKey(const ValueKey("Register"));

      expect(signUpPage, findsOneWidget);

      await tester.tap(signUpPage);
      await tester.pumpAndSettle();

      // Assert that registration was successful
      expect(find.byKey(const ValueKey("email_field")), findsOneWidget);
      expect(find.byKey(const ValueKey("password_field")), findsOneWidget);
      expect(find.byKey(const ValueKey("confirmPassword_field")), findsOneWidget);
    });

    testWidgets('Open Log-in', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: CustomAppBar(
          title: "title",
          isLoggedIn: false))); // Assuming MyApp contains the SignUpPage widget
      final logInPage = find.byKey(const ValueKey("Login"));

      expect(logInPage, findsOneWidget);

      await tester.tap(logInPage);
      await tester.pumpAndSettle();

      // Assert that registration was successful
      expect(find.byKey(const ValueKey("email_field")), findsOneWidget);
      expect(find.byKey(const ValueKey("password_field")), findsOneWidget);
      expect(find.byKey(const ValueKey("login_button")), findsOneWidget);

    });

    testWidgets('Test MockHomePage', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: MockHomePage()));
      final listView = find.byKey(const ValueKey('ListView'));

      expect(listView, findsOneWidget);

    });
  });
  group('CreditPage widget', () {
    testWidgets('should display a "Created by:" heading', (WidgetTester widgetTester) async {
      await widgetTester.pumpWidget(const MaterialApp(home: CreditsPage()));
      final createdByHeadingFinder = find.text('Created by:');
      expect(createdByHeadingFinder, findsOneWidget);
    });

    testWidgets('should display a list of credits', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: CreditsPage()));
      final creditsFinder = find.byType(Text).hitTestable();
      expect(creditsFinder, findsNWidgets(10));
    });

    testWidgets('Displays credit\'s information', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: CreditsPage()));

      expect(find.text('Created by:'), findsOneWidget);
      expect(find.text('Pedro Barros'), findsOneWidget);
      expect(find.text('José Guedes'), findsOneWidget);
      expect(find.text('Rafael Melo'), findsOneWidget);
      expect(find.text('Eduardo Machado'), findsOneWidget);
      expect(find.text('João Sousa'), findsOneWidget);
    });
  });

  testWidgets('AppBar should display correct title', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(appBar: CustomAppBar(title: 'Test', isLoggedIn: false))));
    expect(find.text('Test'), findsOneWidget);
  });

  testWidgets('AppBar should display correct title', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(appBar: CustomAppBar(title: 'Test', isLoggedIn: false))));
    expect(find.text('Test'), findsOneWidget);
  });


  testWidgets('Password mismatch dialog should appear when showPasswordMissMatchDialog is called', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: Builder(
      builder: (BuildContext context) {
        return ElevatedButton(
          onPressed: () {
            showPasswordMissMatchDialog(context);
          },
          child: const Text('Show dialog'),
        );
      },
    ))));

    await tester.tap(find.text('Show dialog'));
    await tester.pumpAndSettle();

    expect(find.text('Error: Password MissMatch'), findsOneWidget);
    expect(find.text('The passwords are not the same try again!'), findsOneWidget);
    expect(find.text('OK'), findsOneWidget);
  });
  /*
  group('FavoriteMoviePage', () {
    testWidgets('should display the title "Favorites" in the app bar', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: FavoriteMoviePage()));
      final titleFinder = find.text('Favorites');
      final isOpen = find.byKey(const ValueKey("Favorite_movies_list"));
      expect(titleFinder, findsOneWidget);
      expect(isOpen, findsOneWidget);
    });
  });*/
}