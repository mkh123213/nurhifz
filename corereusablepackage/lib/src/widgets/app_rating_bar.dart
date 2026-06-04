import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppRatingBar extends StatelessWidget {
  final double rating;
  final int maxRating;
  final double size;
  final Color activeColor;
  final Color inactiveColor;
  final ValueChanged<int>? onRatingChanged;

  const AppRatingBar({
    super.key,
    required this.rating,
    this.maxRating = 5,
    this.size = 24,
    this.activeColor = AppColors.yellow,
    this.inactiveColor = Colors.grey,
    this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxRating, (i) {
        final starValue = i + 1;
        IconData icon;
        Color color;

        if (rating >= starValue) {
          icon = Icons.star_rounded;
          color = activeColor;
        } else if (rating >= starValue - 0.5) {
          icon = Icons.star_half_rounded;
          color = activeColor;
        } else {
          icon = Icons.star_outline_rounded;
          color = inactiveColor;
        }

        final star = Icon(icon, size: size, color: color);

        if (onRatingChanged != null) {
          return GestureDetector(
            onTap: () => onRatingChanged!(starValue),
            child: star,
          );
        }
        return star;
      }),
    );
  }
}
