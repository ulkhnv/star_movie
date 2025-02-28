import 'package:flutter/material.dart';
import 'package:star_movie/src/presentation/theme/app_colors.dart';

class StarRating extends StatelessWidget {
  const StarRating({super.key, required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        5,
        (index) {
          if (index < rating.floor()) {
            return const Icon(
              Icons.star,
              color: AppColors.amber,
              size: 20,
            );
          } else if (index < rating) {
            return const Icon(
              Icons.star_half,
              color: AppColors.amber,
              size: 20,
            );
          } else {
            return const Icon(
              Icons.star_border,
              color: AppColors.amber,
              size: 20,
            );
          }
        },
      ),
    );
  }
}
