import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/battle_settings.dart';
import '../../../models/colap_name.dart';
import 'choice_card.dart';

// ignore: must_be_immutable
class NameCard extends StatefulWidget {
  final void Function(List<String>) onFinished;

  List<ColapName> list;
  NameCard({
    Key? key,
    required this.onFinished,
    required this.list,
  }) : super(key: key);

  @override
  State<NameCard> createState() => _NameCardState();
}

class _NameCardState extends State<NameCard> {
  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<BattleSettings>(context, listen: false);

    List<int> indexes = generateIndex(widget.list.length);

    return Draggable(
        axis: Axis.horizontal,
        childWhenDragging: Container(),
        feedback: Row(
          children: [
            Icon(
              Icons.arrow_back,
              size: 50,
              color: Theme.of(context).colorScheme.primary,
            ),
            ChoiceCard(list: widget.list, indexes: indexes),
            Icon(
              Icons.arrow_forward,
              size: 50,
              color: Theme.of(context).colorScheme.onTertiary,
            ),
          ],
        ),
        onDragEnd: (details) {
          if (details.offset.dx < 0) {
            widget.list.removeAt(indexes.first);
          } else {
            widget.list.removeAt(indexes.last);
          }
          if (settings.twins == true && widget.list.length > 2 ||
              settings.twins == false && widget.list.length > 1) {
            indexes = generateIndex(widget.list.length);
          } else {
            widget.onFinished(widget.list.map((e) => e.name).toList());
          }
          setState(() {});
        },
        child: ChoiceCard(list: widget.list, indexes: indexes));
  }
}

List<int> generateIndex(int max) {
  List<int> indexes = [];
  int i = Random().nextInt(max);
  int j = 0;
  indexes.add(i);
  do {
    j = Random().nextInt(max);
  } while (j == i);
  indexes.add(j);
  return indexes;
}
