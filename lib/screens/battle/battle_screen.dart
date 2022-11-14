import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:colap/commons/colap.page.dart';
import 'package:colap/commons/ui.commons.dart';
import 'package:colap/models/colap_list.dart';
import 'package:colap/models/list_provider.dart';

import '../../models/colap_name.dart';
import '../../services/database_list.dart';
import 'components/chosen_name.dart';
import 'components/name_card.dart';

class BattleScreen extends StatefulWidget {
  const BattleScreen({super.key});

  @override
  State<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends State<BattleScreen> {
  List<ColapName> names = [];
  List<String> chosenNames = [];
  bool finished = false;
  @override
  Widget build(BuildContext context) {
    return ColapPage(
        child: Selector<ListProvider, List<ColapList?>?>(
            selector: (context, provider) {
      return provider.selectedLists;
    }, builder: (context, value, child) {
      if (value != null && value.isNotEmpty) {
        final lists = value;
        return FutureBuilder<List<ColapName>>(
            future: Provider.of<DatabaseListService>(context)
                .getNamesAsFutureInLists(lists.map((e) => e!.uid).toList()),
            initialData: const [],
            builder: (context, future) {
              if (future.hasData && future.data!.isNotEmpty) {
                names = future.data!;
                return Center(
                    child: finished
                        ? ChosenNames(chosenNames: chosenNames)
                        : NameCard(
                            onFinished: (List<String> names) =>
                                showChosenNames(names),
                            list: names,
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

  void showChosenNames(List<String> names) {
    return setState(() {
      chosenNames = names;
      finished = true;
    });
  }
}
