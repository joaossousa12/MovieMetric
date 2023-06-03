import 'package:flutter/material.dart';
import 'package:movie_metric/utils/text.dart';

import '../description.dart';

class TrendingMovies extends StatelessWidget {
  final List trending;

  const TrendingMovies({super.key, required this.trending});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ModifiedText(
            text: 'Trending Movies',
            color: Colors.black,
            size: 26,
          ),
          const SizedBox(height: 10),
          SizedBox(
              height: 270,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: trending.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MovieDescription(
                                  name: (trending[index]['title'] as String?) ?? 'N/A',
                                  bannerurl:
                                  'https://image.tmdb.org/t/p/w500${trending[index]['backdrop_path'] as String? ?? ''}',
                                  posterurl:
                                  'https://image.tmdb.org/t/p/w500${trending[index]['poster_path'] as String? ?? ''}',
                                  description: (trending[index]['overview'] as String?) ?? 'N/A',
                                  vote: (trending[index]['vote_average']?.toString()) ?? 'N/A',
                                  launchOn: (trending[index]['release_date'] as String?) ?? 'N/A',
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
                                      'https://image.tmdb.org/t/p/w500${trending[index]['poster_path'] as String? ?? ''}'),
                                ),
                              ),
                              height: 200,
                            ),
                            const SizedBox(height: 5),
                            ModifiedText(
                                size: 15,
                                color: Colors.black,
                                text: (trending[index]['title'] as String?) ?? 'Loading')
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