import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_metric/firebase_options.dart';
import 'package:movie_metric/models/favoriteMovies.dart';
import 'package:provider/provider.dart';
import 'utils/auth.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets/trending.dart';
import 'widgets/tv.dart';
import 'widgets/topRatedMovies.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie_metric/description.dart';
import 'package:firebase_database/firebase_database.dart';

// Global variables
bool loginInfo = false;

Map<String, List<Review>> movieReviews = {};

const String apikey = '4a46d3f7d62d453cbea342fb675580aa';
const readaccesstoken = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI0YTQ2ZDNmN2Q2MmQ0NTNjYmVhMzQyZmI2NzU1ODBhYSIsInN1YiI6IjY0MzZkNDBhZmQ0ZjgwMDA3N2QzYTY1ZCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.o6ql7Af4MZT6fbZTE5C5kv9c_ZAsu2P20BraBddHMCY';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MovieMetric());
}

class MovieMetric extends StatelessWidget {
  MovieMetric({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      value: FirebaseAuth.instance.idTokenChanges().asyncExpand((user) {
        if (user == null) {
          return Stream.value(FavoriteMovies([]));
        }
        final ref = FirebaseDatabase.instance.ref();
        return ref.child("users/${user.uid}").onValue.map((event){
          if (!event.snapshot.exists) {
            return FavoriteMovies([]);
          }

          final List<Object?> snapshotValue = event.snapshot.value as List<Object?>;
          final List<String> favoriteMovies = snapshotValue.map((value) => value.toString()).toList();

          return FavoriteMovies(favoriteMovies);
        });
      }),
      initialData: FavoriteMovies([]),
        child: MaterialApp(
          title: 'MovieMetric',
          theme: ThemeData(
            primarySwatch: Colors.green,
          ),
          home: HomePage(),
        )
      );
  }
}


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isLoggedIn;

  const CustomAppBar({Key? key, required this.title, required this.isLoggedIn}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: isLoggedIn
          ? [
        TextButton(
          key: const Key("profile_button"),
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (
                    context) => const FavoriteMoviePage(),
              ),
            );
          },
          child: const Text(
            'Favorites',
            style: TextStyle(color: Colors.white),
          ),
        ),
        TextButton(
          key: const Key("logout_button"),
          onPressed: () {
            loginInfo = false;

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
                  (route) => false,
            );

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Successfully logged out!')),
            );
          },
          child: const Text(
            'Logout',
            style: TextStyle(color: Colors.white),
          ),
        ),
        IconButton(
          icon: Image.asset('lib/resources/home.png'),
          key: const Key("home_page"),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
                  (route) => false,
            );
          },
        ),
      ]
          : [
        TextButton(
          key: const Key("login_button"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          },
          child: const Text(
            key: Key("Login"),
            'Login',
            style: TextStyle(color: Colors.white),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SignUpPage()),
            );
          },
          child: const Text(
            key: Key("Register"),
            'Register',
            style: TextStyle(color: Colors.white),
          ),
        ),
        IconButton(
          key: const Key("register_button"),
          icon: Image.asset('lib/resources/home.png'),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
                  (route) => false,
            );
          },
        ),
      ],
    );
  }
}

class CustomAppBarFav extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isLoggedIn;

  const CustomAppBarFav({Key? key, required this.title, required this.isLoggedIn}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: isLoggedIn
          ? [
        TextButton(
          onPressed: () {
            loginInfo = false;

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
                  (route) => false,
            );

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Successfully logged out!')),
            );
          },
          child: const Text(
            'Logout',
            style: TextStyle(color: Colors.white),
          ),
        ),
        IconButton(
          icon: Image.asset('lib/resources/home.png'),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
                  (route) => false,
            );
          },
        ),
      ]
          : [
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          },
          child: const Text(
            'Login',
            style: TextStyle(color: Colors.white),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SignUpPage()),
            );
          },
          child: const Text(
            key: Key("Register"),
            'Register',
            style: TextStyle(color: Colors.white),
          ),
        ),
        IconButton(
          icon: Image.asset('lib/resources/home.png'),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
                  (route) => false,
            );
          },
        ),
      ],
    );
  }
}


class CustomAppBarLoginSignUp extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBarLoginSignUp({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: [
        IconButton(
          key: const Key("home_page"),
          icon: Image.asset('lib/resources/home.png'),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
                  (route) => false,
            );
          },
        ),
      ],
    );
  }
}

showPasswordMissMatchDialog(BuildContext context) {

  Widget okButton = TextButton(
    child: const Text("OK"),
    onPressed: () { },
  );


  AlertDialog alert = AlertDialog(
    title: const Text("Error: Password MissMatch"),
    content: const Text("The passwords are not the same try again!"),
    actions: [
      okButton,
    ],
  );


  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();

  String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {return key.toString();}
}

class HomePageState extends State<HomePage> {

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


  void initState() {
    super.initState();
    loadmovies(); // Call loadmovies method
    _loadLoggedInEmail();
  }

  loadmovies()async{
    TMDB tmbdbWithCustomLogs = TMDB(ApiKeys(apikey, readaccesstoken),
        logConfig: const ConfigLogger(
            showLogs: true,
            showErrorLogs: true
        ));
    Map topRatedResult = await tmbdbWithCustomLogs.v3.movies.getTopRated();
    Map trendingResult = await tmbdbWithCustomLogs.v3.trending.getTrending();
    Map tvResult = await tmbdbWithCustomLogs.v3.tv.getPopular();
    setState(() {
      topRatedMovies = topRatedResult['results'];
      trendingMovies = trendingResult['results'];
      tv = tvResult['results'];
    });
  }

  String _loggedInEmail = '';
  String? _loggedInMessage;

  Future<void> _loadLoggedInEmail() async { // usage of local storage
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
      appBar: CustomAppBar(title: 'MovieMetric', isLoggedIn: loginInfo),
      body: ListView(
        children: [
          TV(tv: tv),
          TrendingMovies(
            trending: trendingMovies,
          ),
          TopRatedMovies(
            toprated: topRatedMovies,
          ),
          Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (_loggedInMessage != null) Text(_loggedInMessage!),
                const SizedBox(height: 24),
                ElevatedButton(
                  key: const Key("credits_button"),
                  onPressed: _goToCreditsPage,
                  child: const Text('Credits'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


}


class CreditsPage extends StatelessWidget {
  const CreditsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'MovieMetric', isLoggedIn: loginInfo),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'MovieMetric',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Created by:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Pedro Barros',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'José Guedes',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Rafael Melo',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Eduardo Machado',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'João Sousa',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SignUpPage extends StatefulWidget{
  const SignUpPage({Key? key}) : super(key: key);

  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final Auth1 _auth = Auth1();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarLoginSignUp(title: 'Sign Up'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              key: const Key("email_field"),
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'E-mail',
                hintText: 'Enter your e-mail',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              key: const Key("password_field"),
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your desired password',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              key: const Key("confirmPassword_field"),
              controller: _confirmPasswordController,
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
                hintText: 'Re-enter your password',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              key: const Key("signUp_button"),
              onPressed: () async {
                if (_passwordController.text.trim() == _confirmPasswordController.text.trim()) {
                  try {
                    await _auth.createUserWithEmailAndPassword(
                      email: _emailController.text.trim(),
                      password: _passwordController.text.trim(),
                    );
                    if(mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Registered Successfully!')),
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (
                              context) => const LoginPage(),
                        ),
                      );
                    }

                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: ${e.toString()}')),
                    );
                  }
                } else {
                  showPasswordMissMatchDialog(context);
                }
              },
              child: const Text('Sign Up'),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              },
              child: const Text('Already have an account? Log-In'),
            ),
          ],
        ),
      ),
    );
  }
}


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameEmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadRememberMePreference();
  }

  final Auth1 _auth = Auth1();

  Future<void> _loadRememberMePreference() async {
    final prefs = await SharedPreferences.getInstance();
    bool rememberMe = prefs.getBool('remember_me') ?? false;
    setState(() {
      _rememberMe = rememberMe;
    });
  }

  Future<void> _saveRememberMePreference(bool rememberMe) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('remember_me', rememberMe);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarLoginSignUp(title: 'Login'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              key: const Key("email_field"),
              controller: _usernameEmailController,
              decoration: const InputDecoration(
                labelText: 'Username or e-mail',
                hintText: 'Enter your email or username',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              key: const Key("password_field"),
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: _rememberMe,
                  onChanged: (bool? value) {
                    setState(() {
                      _rememberMe = value ?? false;
                    });
                  },
                ),
                const Text('Remember me'),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              key: const Key("login_button"),
              onPressed: () async {
                try {
                  await _auth.signInWithEmailAndPassword(
                    email: _usernameEmailController.text,
                    password: _passwordController.text,
                  );
                  await _saveRememberMePreference(_rememberMe);

                  if (context.mounted) {
                    loginInfo = true;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ),
                    );
                  }

                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}')),
                  );
                }
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignUpPage(),
                  ),
                );
              },
              child: const Text('Don\'t have an account? Sign up'),
            ),
          ],
        ),
      ),
    );
  }
}

Future<List<dynamic>> searchMovies(String query) async {
  var url = Uri.parse('https://api.themoviedb.org/3/search/movie');
  var response = await http.get(url.replace(queryParameters: {
    'api_key': apikey,
    'query': query,
  }));
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    return data['results'];
  } else {
    throw Exception('Failed to load movies');
  }
}

class MoviePoster extends StatelessWidget {
  final String movieName;

  const MoviePoster({super.key, required this.movieName});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: searchMovies(movieName),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.hasData) {
          var results = snapshot.data!;
          if (results.isNotEmpty) {
            var movie = results.first;
            var posterPath = movie['poster_path'];
            return Image.network(
              'https://image.tmdb.org/t/p/w500$posterPath',
              fit: BoxFit.cover,
            );
          }
        }
        return Container();
      },
    );
  }
}

class FavoriteMoviePage extends StatefulWidget{
  const FavoriteMoviePage({Key? key}) : super(key: key);

  @override
  FavoriteMoviePageState createState() => FavoriteMoviePageState();
}

class FavoriteMoviePageState extends State<FavoriteMoviePage>{

  @override
  Widget build(BuildContext context){
    final favoriteMovies = Provider.of<FavoriteMovies>(context);
    return Scaffold(
      appBar: CustomAppBarFav(title: 'Favorites', isLoggedIn: loginInfo),
      key: const Key("Favorite_movies_list"),
      body: GridView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: favoriteMovies!.FavMoviesList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.6,
          ),
          itemBuilder: (BuildContext context, int index){
            final String movieName = favoriteMovies.FavMoviesList[index];

            return Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 150,
                      width: 100,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: MoviePoster(movieName: movieName),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(movieName),
                  ],
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    key: const Key("favorite_button"),
                    onTap: (){
                      setState(()  {
                        final user = FirebaseAuth.instance.currentUser;
                        final databaseRef = FirebaseDatabase.instance.ref();

                        if (user != null) {
                          final uid = user.uid;
                          databaseRef.child('users/$uid').once().then((snapshot) {
                            List<dynamic> moviesSnapshot = [];
                            List<dynamic> newMoviesSnapshot = [];

                            if (snapshot.snapshot.exists) {
                              moviesSnapshot = List<dynamic>.from(snapshot.snapshot.value as List<dynamic>);
                            }
                            int index = 0;
                            for(int i = 0; i < moviesSnapshot.length; i++){
                              if(moviesSnapshot[i] == movieName){
                                index = i;
                                break;
                              }
                              newMoviesSnapshot.add(moviesSnapshot[i]);
                            }

                            for(int j = index + 1; j < moviesSnapshot.length; j++){
                              newMoviesSnapshot.add(moviesSnapshot[j]);
                            }

                            databaseRef.child('users/$uid').set(newMoviesSnapshot);
                          });
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white.withOpacity(0), // 0 opacity so background isn't shown
                      ),
                      child: Image.asset(
                        'lib/resources/x.png',
                        height: 20,
                        width: 20,
                      ),
                    ),
                  ),
                )
              ],
            );
          }
      ),
    );
  }
}
