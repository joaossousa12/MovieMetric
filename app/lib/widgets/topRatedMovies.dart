import 'package:flutter/material.dart';
import 'package:movie_metric/utils/text.dart';
import 'package:movie_metric/description.dart';

class TopRatedMovies extends StatelessWidget {
  final List toprated;

  const TopRatedMovies({super.key, required this.toprated});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ModifiedText(
            text: 'Top Rated Movies',
            color: Colors.black,
            size: 26,
          ),
          const SizedBox(height: 10),
          SizedBox(
              height: 300,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: toprated.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MovieDescription(
                                  name: (toprated[index]['title'] as String?) ?? 'N/A',
                                  bannerurl:
                                  'https://image.tmdb.org/t/p/w500${toprated[index]['backdrop_path'] as String? ?? ''}',
                                  posterurl:
                                  'https://image.tmdb.org/t/p/w500${toprated[index]['poster_path'] as String? ?? ''}',
                                  description: (toprated[index]['overview'] as String?) ?? 'N/A',
                                  vote: (toprated[index]['vote_average']?.toString()) ?? 'N/A',
                                  launchOn: (toprated[index]['release_date'] as String?) ?? 'N/A',
                                )));
                      },
                      child: SizedBox(
                        width: 140,
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                      'https://image.tmdb.org/t/p/w500${toprated[index]['poster_path'] as String? ?? ''}'),
                                ),
                              ),
                              height: 200,
                            ),
                            const SizedBox(height: 5),
                            ModifiedText(
                                size: 15,
                                color: Colors.black,
                                text: (toprated[index]['title'] as String?) ?? 'Loading')
                          ],
                        ),
                      ),
                    );
                  }))
        ],
      ),
    );
  }
}
