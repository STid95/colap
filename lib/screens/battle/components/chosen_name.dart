import 'package:flutter/material.dart';

class ChosenName extends StatelessWidget {
  const ChosenName({
    Key? key,
    required this.chosenName,
  }) : super(key: key);

  final String chosenName;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text("Et le nom choisi est...",
            style: Theme.of(context).textTheme.headline1),
        Text(chosenName,
            style: Theme.of(context)
                .textTheme
                .headline1!
                .copyWith(color: Theme.of(context).colorScheme.primary)),
      ],
    );
  }
}
