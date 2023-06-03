import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:movie_metric/main.dart';
import 'package:movie_metric/utils/text.dart';
import 'dart:math';

import 'package:provider/provider.dart';

import 'models/favoriteMovies.dart';

class Review {
  final String comment;
  final double rating;

  Review({required this.comment, required this.rating});
}

class MovieDescription extends StatefulWidget {
  final String name, description, bannerurl, posterurl, vote, launchOn;
  bool isFavorite;

  MovieDescription({
    super.key,
    required this.name,
    required this.description,
    required this.bannerurl,
    required this.posterurl,
    required this.vote,
    required this.launchOn,
    this.isFavorite = false,
  });

  @override
  _DescriptionState createState() => _DescriptionState();
}

class _DescriptionState extends State<MovieDescription> {
  TextEditingController _commentController = TextEditingController();
  double _rating = 0.0;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'MovieMetric', isLoggedIn: loginInfo),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          SizedBox(
            height: 250,
            child: Stack(
              children: [
                Positioned(
                  child: SizedBox(
                    height: 250,
                    width: MediaQuery.of(context).size.width,
                    child: Image.network(
                      widget.bannerurl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  child: ModifiedText(
                      text: '⭐ Average Rating - ${widget.vote.substring(0, min(4, widget.vote.length))}',
                      color: Colors.white,
                      size: 26),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: ModifiedText(
                      text: widget.name, color: Colors.black, size: 24),
                ),
                InkWell(
                    child: Image.asset(
                      widget.isFavorite
                          ? 'lib/resources/heart_filled.png'
                          : 'lib/resources/heart.png',
                      height: 24,
                      width: 24,
                    ),
                    onTap: () {
                      if (loginInfo) {
                        setState(() {
                          final favoriteMovies = Provider.of<FavoriteMovies>(context, listen: false);
                          if (!favoriteMovies.FavMoviesList.contains(widget.name)) {

                            final user = FirebaseAuth.instance.currentUser;
                            final databaseRef = FirebaseDatabase.instance.ref();

                            if(user != null){
                              final uid = user.uid;
                              databaseRef.child('users/$uid').once().then((snapshot){
                                List<dynamic> moviesSnapshot = [];
                                if(snapshot.snapshot.exists)  moviesSnapshot = List<dynamic>.from(snapshot.snapshot.value as List<dynamic>);
                                final newMovie = widget.name;
                                moviesSnapshot.add(newMovie);
                                databaseRef.child('users/$uid').set(moviesSnapshot);
                              });
                            }

                            widget.isFavorite = true;
                          } else {
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
                                  if(moviesSnapshot[i] == widget.name){
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

                            widget.isFavorite = false;
                          }
                        });
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'You need to be logged in to use this feature!')),
                        );
                      }
                    }),
              ],
            ),
          ),
          Container(
              padding: const EdgeInsets.only(left: 10),
              child: ModifiedText(
                  text: 'Releasing On - ${widget.launchOn}',
                  color: Colors.black,
                  size: 14)),
          Row(
            children: [
              SizedBox(
                height: 200,
                width: 100,
                child: Image.network(widget.posterurl),
              ),
              Flexible(
                child: Container(
                    padding: const EdgeInsets.all(10),
                    child: ModifiedText(
                        text: widget.description,
                        color: Colors.black,
                        size: 18)),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Add your review:', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 5),
                TextField(
                  controller: _commentController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Write your review here...',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                const Text('Rate this movie:', style: TextStyle(fontSize: 16)),
                Slider(
                  value: _rating,
                  onChanged: (double newValue) {
                    setState(() {
                      _rating = newValue;
                    });
                  },
                  min: 0,
                  max: 10,
                  divisions: 20,
                  label: _rating.toStringAsFixed(1),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    if(loginInfo) {
                      setState(() {
                        if (!movieReviews.containsKey(widget.name)) {
                          movieReviews[widget.name] = [];
                        }
                        movieReviews[widget.name]?.add(Review(
                            comment: _commentController.text, rating: _rating));
                        _commentController.clear();
                        _rating = 0.0;
                      });
                    }else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('You need to be logged in to submit a review!')),
                      );
                    }
                  },
                  child: const Text('Submit'),
                ),
                const SizedBox(height: 20),
                const Text('Reviews:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemCount: movieReviews.containsKey(widget.name) ? movieReviews[widget.name]!.length : 0,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(movieReviews[widget.name]![index].comment),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('⭐ ${movieReviews[widget.name]![index].rating.toStringAsFixed(1)}'),
                              const SizedBox(width: 8),
                              InkWell(
                                  child: Image.asset(
                                    'lib/resources/edit.png',
                                    height: 24,
                                    width: 24,
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _commentController.text = movieReviews[widget.name]![index].comment;
                                      _rating = double.tryParse(movieReviews[widget.name]![index].rating.toStringAsFixed(1)) ?? 0.0;
                                      movieReviews[widget.name]?.removeAt(index);
                                    });
                                  }
                              ),
                              const SizedBox(width: 8),
                              InkWell(
                                child: Image.asset(
                                  'lib/resources/trash.png',
                                  height: 24,
                                  width: 24,
                                ),
                                onTap: () {
                                  setState(() {
                                    movieReviews[widget.name]?.removeAt(index);
                                  });
                                }
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


