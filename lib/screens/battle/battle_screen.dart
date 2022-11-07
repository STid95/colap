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
                        ? ChosenName(chosenName: chosenName)
                        : NameCard(
                            onFinished: (String name) => showChosenName(name),
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

  void showChosenName(String name) {
    return setState(() {
      chosenName = name;
      finished = true;
    });
  }
}
