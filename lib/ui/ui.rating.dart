import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class UIRating extends StatelessWidget {
  final double initialRating;
  final void Function(double rating) onUpdate;
  const UIRating({
    Key? key,
    required this.initialRating,
    required this.onUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
        itemSize: 30,
        initialRating: initialRating,
        direction: Axis.horizontal,
        allowHalfRating: false,
        itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
        itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.purpleAccent,
            ),
        onRatingUpdate: (rating) {
          onUpdate(rating);
        });
  }
}
