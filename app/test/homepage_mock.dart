
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_metric/main.dart';
import 'package:movie_metric/widgets/topRatedMovies.dart';
import 'package:movie_metric/widgets/trending.dart';
import 'package:movie_metric/widgets/tv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:mockito/mockito.dart';

class MockTMDB extends Mock implements TMDB {}

class MockHomePage extends StatefulWidget {
  const MockHomePage({Key? key}) : super(key: key);

  @override
  MockHomePageState createState() => MockHomePageState();

  String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {return key.toString();}
}

class MockHomePageState extends State<MockHomePage> {

  List topRatedMovies = [];
  List trendingMovies = [];
  List tv = [];

  void _goToCreditsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreditsPage(),
      ),
    );
  }

  void _goToFavoriteMoviesPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FavoriteMoviePage(),
      ),
    );
  }

  void initState() {
    loginInfo = true;
    super.initState();
    loadmovies();
    _loadLoggedInEmail();
  }

  loadmovies()async{
    MockTMDB tmbdbWithCustomLogs = MockTMDB();
    setState(() {
      topRatedMovies = [];
      trendingMovies = [];
      tv = [];
    });
  }

  String _loggedInEmail = '';
  String? _loggedInMessage;

  Future<void> _loadLoggedInEmail() async {
    final prefs = await SharedPreferences.getInstance();
    String loggedInEmail = prefs.getString('loggedInEmail') ?? '';
    setState(() {
      _loggedInEmail = loggedInEmail;
      if (_loggedInEmail.isNotEmpty) {
        _loggedInMessage = 'You are logged in as $_loggedInEmail';
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'MovieMetric', isLoggedIn : loginInfo),
      body: ListView(
        key: const Key("ListView"),
        children: [
          TV(tv: tv),
          TrendingMovies(
            trending: trendingMovies,
          ),
          TopRatedMovies(
            toprated: topRatedMovies,
          ),
          Container(
            key: const Key("Container"),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (_loggedInMessage != null) Text(_loggedInMessage!),
                const SizedBox(height: 24),
                ElevatedButton(
                  key: const Key("credits_button"),
                  onPressed: () {Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CreditsPage()),
                  );
                  },
                  child: const Text('Credits'),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                   key: const Key("Favorite"),
                   onPressed: () {Navigator.push(
                     context,
                     MaterialPageRoute(builder: (context) => const FavoriteMoviePage()),
                   );
                   },
                   child: const Text('Favorites')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}