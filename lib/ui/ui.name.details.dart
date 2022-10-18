import 'package:colap/models/colap_list.dart';
import 'package:colap/models/colap_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../models/colap_user.dart';

class UINameDetails extends StatelessWidget {
  final ColapName name;
  const UINameDetails({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final list = Provider.of<ColapList>(context, listen: false);
    final user = Provider.of<ColapUser>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 5),
        Row(
          children: [
            Text(
              list.user1,
              style: const TextStyle(fontSize: 17),
            ),
            const SizedBox(width: 10),
            Expanded(
                child: user.name == list.user1
                    ? RatingBar.builder(
                        initialRating: name.grade1.toDouble(),
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.purpleAccent,
                            ),
                        onRatingUpdate: (rating) {
                          name.grade1 = rating.toInt();
                          name.updateRating1(list.uid!);
                        })
                    : RatingBarIndicator(
                        itemBuilder: (context, _) =>
                            const Icon(Icons.star, color: Colors.purpleAccent),
                        itemCount: 5,
                        rating: name.grade1.toDouble())),
          ],
        ),
        Row(
          children: [
            Text(
              list.user2,
              style: const TextStyle(fontSize: 17),
            ),
            const SizedBox(width: 10),
            Expanded(
                child: user.name == list.user2
                    ? RatingBar.builder(
                        initialRating: name.grade2.toDouble(),
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.purpleAccent,
                            ),
                        onRatingUpdate: (rating) {
                          name.grade2 = rating.toInt();
                          //name.updateRating2(list.uid!);
                        })
                    : RatingBarIndicator(
                        itemBuilder: (context, _) =>
                            const Icon(Icons.star, color: Colors.purpleAccent),
                        itemCount: 5,
                        rating: name.grade2.toDouble())),
          ],
        ),
        if (name.comment.isNotEmpty) ...[
          const SizedBox(height: 10),
          Text(
            name.comment,
            style: const TextStyle(fontSize: 17),
          ),
        ]
      ]),
    );
  }
}
