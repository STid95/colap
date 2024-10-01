import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../commons/ui.commons.dart';
import '../../../models/colap_list.dart';
import '../../../models/colap_user.dart';
import 'name_details.dart';

class UserGrade extends StatelessWidget {
  const UserGrade({
    Key? key,
    required this.userGrade,
    required this.list,
    required this.currentUser,
    required this.widget,
  }) : super(key: key);

  final String userGrade;
  final ColapList list;
  final ColapUser currentUser;
  final NameDetails widget;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            userGrade,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
            width: 150,
            child: currentUser.name == userGrade
                ? UIRating(
                    itemSize: MediaQuery.of(context).size.width * 0.06,
                    initialRating: currentUser.name == list.users.first && userGrade == currentUser.name
                        ? widget.name.grade1.toDouble()
                        : widget.name.grade2.toDouble(),
                    onUpdate: (rating) {
                      widget.name.grade1 = rating.toInt();
                      widget.name.updateRating1(list.uid!);
                    })
                : RatingBarIndicator(
                    itemSize: MediaQuery.of(context).size.width * 0.06,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                    itemBuilder: (context, _) => const Icon(Icons.star),
                    itemCount: 5,
                    rating: currentUser.name == list.users.first && userGrade == currentUser.name
                        ? widget.name.grade1.toDouble()
                        : widget.name.grade2.toDouble(),
                  )),
      ],
    );
  }
}
