import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import 'package:colap/models/colap_name.dart';
import 'package:colap/services/database_name.dart';
import 'package:colap/screens/lists/components/name_details.dart';

import 'dialogs/remove_dialog.dart';

class NamePreview extends StatefulWidget {
  final String nameId;
  final String listId;
  final String name;
  final num averageGrade;
  const NamePreview({
    Key? key,
    required this.nameId,
    required this.listId,
    required this.name,
    required this.averageGrade,
  }) : super(key: key);

  @override
  State<NamePreview> createState() => _NamePreviewState();
}

class _NamePreviewState extends State<NamePreview>
    with SingleTickerProviderStateMixin {
  bool details = false;
  late final AnimationController _controller;
  late final CurvedAnimation animation;
  final Duration duration = const Duration(milliseconds: 800);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: duration);
    _controller.addListener(() {
      setState(() {});
    });
    animation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        1 / 3,
        1 / 3 * 1.5,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleAnimation() {
    if (_controller.status == AnimationStatus.completed) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(children: [
        AnimatedBuilder(
          animation: animation,
          builder: (context, child) => Visibility(
            visible: animation.value >= 0.5,
            child: Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(pi + pi * animation.value),
              alignment: FractionalOffset.topCenter,
              child: GestureDetector(
                onTap: _toggleAnimation,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        StreamProvider<ColapName>.value(
                          value: Provider.of<DatabaseNameListService>(context)
                              .getName(widget.listId, widget.nameId),
                          initialData: ColapName(name: ''),
                          builder: (context, child) {
                            ColapName name = Provider.of<ColapName>(context);
                            return NameDetails(
                              name: name,
                              onDelete: () => setState(() {
                                details = false;
                              }),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: animation.value < 0.5,
          child: ListTile(
            onTap: _toggleAnimation,
            contentPadding: EdgeInsets.zero,
            horizontalTitleGap: 0,
            title: SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Text(
                widget.name,
                style: Theme.of(context).textTheme.headline5,
                overflow: TextOverflow.clip,
              ),
            ),
            leading: InkWell(
                child: Icon(Icons.delete,
                    size: 20, color: Theme.of(context).colorScheme.primary),
                onTap: () => showRemoveDialog(context, (() {
                      setState(() {
                        details = false;
                      });
                      ColapName(name: widget.name, uid: widget.nameId)
                          .remove(widget.listId);
                    }))),
            trailing: Hero(
              tag: widget.nameId,
              child: RatingBarIndicator(
                  itemSize: 30,
                  itemBuilder: (context, _) => Icon(Icons.star,
                      color: Theme.of(context).colorScheme.primary),
                  itemCount: 5,
                  rating: widget.averageGrade.toDouble()),
            ),
          ),
        )
      ]),
    );
  }
}
