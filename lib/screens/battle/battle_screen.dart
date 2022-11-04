import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:colap/commons/colap.page.dart';
import 'package:colap/commons/ui.commons.dart';
import 'package:colap/models/colap_list.dart';
import 'package:colap/models/list_provider.dart';

import '../../models/colap_name.dart';
import '../../services/database_list.dart';

class BattleScreen extends StatefulWidget {
  const BattleScreen({super.key});

  @override
  State<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends State<BattleScreen> {
  String chosenName = '';
  bool finished = false;
  @override
  Widget build(BuildContext context) {
    return ColapPage(
        child:
            Selector<ListProvider, ColapList?>(selector: (context, provider) {
      return provider.selectedList;
    }, builder: (context, value, child) {
      if (value != null) {
        final list = value;
        return FutureBuilder<List<ColapName>>(
            future: Provider.of<DatabaseListService>(context)
                .getNamesAsFuture(list.uid!),
            initialData: const [],
            builder: (context, future) {
              if (future.hasData && future.data!.isNotEmpty) {
                list.names = future.data!;
                return Center(
                    child: finished
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text("Et le nom choisi est...",
                                  style: Theme.of(context).textTheme.headline1),
                              Text(chosenName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary)),
                            ],
                          )
                        : NameCard(
                            onFinished: (String name) => setState(() {
                              chosenName = name;
                              finished = true;
                            }),
                            list: list.names,
                          ));
              } else {
                return circularProgress();
              }
            });
      } else {
        return const Text("Aucune liste trouvée");
      }
    }));
  }
}

class NameCard extends StatefulWidget {
  void Function(String) onFinished;

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
            widget.list.removeAt(indexes.last);
          } else {
            widget.list.removeAt(indexes.first);
          }
          if (widget.list.length > 1) {
            indexes = generateIndex(widget.list.length);
          } else {
            widget.onFinished(widget.list.first.name);
          }
          setState(() {});
        },
        child: ChoiceCard(list: widget.list, indexes: indexes));
  }
}

class ChoiceCard extends StatelessWidget {
  const ChoiceCard({
    Key? key,
    required this.list,
    required this.indexes,
  }) : super(key: key);

  final List<ColapName> list;
  final List<int> indexes;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.9,
      width: MediaQuery.of(context).size.width * 0.9,
      child: Card(
          child: Padding(
        padding: const EdgeInsets.all(20),
        child: list.isEmpty
            ? circularProgress()
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        list[indexes.first].name,
                        style: Theme.of(context).textTheme.headline1!.copyWith(
                            color: Theme.of(context).colorScheme.primary),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Text("OU", style: Theme.of(context).textTheme.headline1),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        list[indexes.last].name,
                        style: Theme.of(context).textTheme.headline1!.copyWith(
                            color: Theme.of(context).colorScheme.onTertiary),
                      ),
                    ),
                  ]),
      )),
    );
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
