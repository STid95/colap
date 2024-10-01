import 'package:flutter/material.dart';

import '../../../commons/ui.commons.dart';
import '../../../models/colap_name.dart';

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
            : Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    list[indexes.first].name,
                    style:
                        Theme.of(context).textTheme.labelLarge!.copyWith(color: Theme.of(context).colorScheme.primary),
                    textAlign: TextAlign.left,
                  ),
                ),
                Text("OU", style: Theme.of(context).textTheme.labelLarge),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    list[indexes.last].name,
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(color: Theme.of(context).colorScheme.onTertiary),
                  ),
                ),
              ]),
      )),
    );
  }
}
