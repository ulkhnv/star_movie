import 'package:flutter/material.dart';
import 'package:star_movie/src/presentation/models/movie_cover_ui_model.dart';
import 'package:star_movie/src/presentation/widgets/home/movie_card.dart';

class MovieGridView extends StatefulWidget {
  const MovieGridView({
    super.key,
    required this.movies,
  });

  final List<MovieCoverUIModel> movies;

  @override
  State<MovieGridView> createState() => _MovieGridViewState();
}

class _MovieGridViewState extends State<MovieGridView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: widget.movies.length,
      itemBuilder: (context, index) {
        final movie = widget.movies[index];
        return MovieCard(
          key: ValueKey(movie.id),
          model: movie,
        );
      },
    );
  }
}
