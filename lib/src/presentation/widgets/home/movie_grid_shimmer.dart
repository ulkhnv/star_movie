import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:star_movie/src/presentation/theme/app_colors.dart';
import 'package:star_movie/src/presentation/theme/app_spacing.dart';

class MovieGridShimmer extends StatelessWidget {
  const MovieGridShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: 4,
      itemBuilder: (context, index) => _buildShimmerMovieCard(),
    );
  }

  Widget _buildShimmerMovieCard() {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      final height = width * 1.5;
      return Shimmer.fromColors(
        baseColor: AppColors.shimmer,
        highlightColor: AppColors.shimmerLight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: height,
              width: width,
              color: AppColors.white,
            ),
            const SizedBox(height: AppSpacing.small),
            Container(
              height: 12,
              width: width,
              color: AppColors.white,
            ),
            const SizedBox(height: AppSpacing.extraSmall),
            Container(
              height: 12,
              width: width,
              color: AppColors.white,
            ),
          ],
        ),
      );
    });
  }
}
