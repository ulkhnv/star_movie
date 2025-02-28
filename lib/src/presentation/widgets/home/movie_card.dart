import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:star_movie/src/presentation/models/movie_cover_ui_model.dart';
import 'package:star_movie/src/presentation/theme/app_colors.dart';
import 'package:star_movie/src/presentation/theme/app_spacing.dart';
import 'package:star_movie/src/presentation/widgets/home/star_rating.dart';

class MovieCard extends StatefulWidget {
  const MovieCard({super.key, required this.model});

  final MovieCoverUIModel model;

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = width * 1.5;

          return CachedNetworkImage(
            imageUrl: widget.model.fullPosterPath,
            fit: BoxFit.cover,
            width: width,
            height: height,
            placeholder: (context, url) => Container(
              height: height,
              color: AppColors.shimmer,
            ),
            errorWidget: (context, url, error) => const Icon(
              Icons.error,
              size: 50,
            ),
          );
        }),
        const SizedBox(height: AppSpacing.small),
        StarRating(rating: widget.model.voteAverageRounded),
        const SizedBox(height: AppSpacing.extraSmall),
        Text(
          widget.model.title,
          style: Theme.of(context).textTheme.titleSmall,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        const SizedBox(height: AppSpacing.extraSmall),
        Text(
          widget.model.genreNames.join(" • "),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.grey,
              ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    );
  }
}
