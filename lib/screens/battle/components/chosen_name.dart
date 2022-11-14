import 'package:flutter/material.dart';

class ChosenNames extends StatelessWidget {
  const ChosenNames({
    Key? key,
    required this.chosenNames,
  }) : super(key: key);

  final List<String> chosenNames;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
              chosenNames.length < 2
                  ? "Et le nom choisi est..."
                  : "Et les noms choisis sont...",
              style: Theme.of(context).textTheme.headline1),
          ...chosenNames.map((e) => Text(e,
              style: Theme.of(context)
                  .textTheme
                  .headline1!
                  .copyWith(color: Theme.of(context).colorScheme.primary))),
        ],
      ),
    );
  }
}
