import 'package:flutter/material.dart';
import 'package:movie_metric/utils/text.dart';
import 'package:movie_metric/description.dart';

class TV extends StatelessWidget {
  final List tv;

  const TV({Key? key, required this.tv}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ModifiedText(
            text: 'Popular TV Shows',
            color: Colors.black,
            size: 26,
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 270,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: tv.length,
                itemBuilder: (context, index) {

                  return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MovieDescription(
                                  name: (tv[index]['name'] as String?) ?? 'N/A',
                                  bannerurl:
                                  'https://image.tmdb.org/t/p/w500${tv[index]['backdrop_path'] as String? ?? ''}',
                                  posterurl:
                                  'https://image.tmdb.org/t/p/w500${tv[index]['poster_path'] as String? ?? ''}',
                                  description: (tv[index]['overview'] as String?) ?? 'N/A',
                                  vote: (tv[index]['vote_average']?.toString()) ?? 'N/A',
                                  launchOn: (tv[index]['first_air_date'] as String?) ?? 'N/A',
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
                                      'https://image.tmdb.org/t/p/w500${tv[index]['poster_path'] as String? ?? ''}'),
                                ),
                              ),
                              height: 200,
                            ),
                            const SizedBox(height: 5),
                            ModifiedText(
                                size: 15,
                                color: Colors.black,
                                text: (tv[index]['name'] as String?) ?? 'Loading')
                          ],
                        ),
                      ),
                    );
                }),
          )
        ],
      ),
    );
  }
}
