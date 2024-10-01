import 'package:flutter/material.dart';

Future<void> showRemoveDialog(BuildContext context, Function() onDelete) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return RemoveDialog(
        onDelete: onDelete,
      );
    },
  );
}

class RemoveDialog extends StatelessWidget {
  final Function() onDelete;
  const RemoveDialog({
    Key? key,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        height: 150,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text("Etes-vous sûr.e ?",
                style: Theme.of(context).textTheme.labelMedium!.copyWith(fontWeight: FontWeight.bold)),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              IconButton(
                icon: const Icon(Icons.cancel),
                onPressed: () => Navigator.pop(context),
              ),
              IconButton(
                  onPressed: (() {
                    onDelete();
                    Navigator.pop(context);
                  }),
                  icon: const Icon(Icons.check))
            ])
          ]),
        ),
      ),
    );
  }
}
