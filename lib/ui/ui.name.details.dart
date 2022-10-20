import 'package:colap/models/colap_list.dart';
import 'package:colap/models/colap_name.dart';
import 'package:colap/ui/ui.rating.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../models/colap_user.dart';

class UINameDetails extends StatefulWidget {
  final void Function() onDelete;
  final ColapName name;
  const UINameDetails({
    Key? key,
    required this.name,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<UINameDetails> createState() => _UINameDetailsState();
}

class _UINameDetailsState extends State<UINameDetails> {
  bool edit = false;
  @override
  Widget build(BuildContext context) {
    final TextEditingController commentController =
        TextEditingController(text: widget.name.comment);

    final list = Provider.of<ColapList>(context, listen: false);
    final user = Provider.of<ColapUser>(context);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Align(
        alignment: Alignment.topRight,
        child: InkWell(
          child: const Icon(Icons.delete),
          onTap: () {
            widget.onDelete();
            widget.name.remove(list.uid!);
          },
        ),
      ),
      const SizedBox(height: 10),
      Row(children: [
        Text(widget.name.name, style: const TextStyle(fontSize: 25))
      ]),
      const SizedBox(height: 10),
      RatingBarIndicator(
          itemSize: 50,
          itemBuilder: (context, _) =>
              const Icon(Icons.star, color: Colors.purpleAccent),
          itemCount: 5,
          rating: widget.name.averageGrade.toDouble()),
      const SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              list.users[0],
              style: const TextStyle(fontSize: 17),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
              width: 200,
              child: user.name == list.users[0]
                  ? UIRating(
                      initialRating: widget.name.grade1.toDouble(),
                      onUpdate: (rating) {
                        widget.name.grade1 = rating.toInt();
                        widget.name.updateRating1(list.uid!);
                      })
                  : RatingBarIndicator(
                      itemSize: 35,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                      itemBuilder: (context, _) =>
                          const Icon(Icons.star, color: Colors.purpleAccent),
                      itemCount: 5,
                      rating: widget.name.grade1.toDouble())),
        ],
      ),
      if (list.users.length > 1)
        Row(
          children: [
            Expanded(
              child: Text(
                list.users[1],
                style: const TextStyle(fontSize: 17),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 200,
              child: user.name == list.users[1]
                  ? UIRating(
                      initialRating: widget.name.grade2.toDouble(),
                      onUpdate: (rating) {
                        widget.name.grade2 = rating.toInt();
                        widget.name.updateRating2(list.uid!);
                      })
                  : RatingBarIndicator(
                      itemSize: 35,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                      itemBuilder: (context, _) =>
                          const Icon(Icons.star, color: Colors.purpleAccent),
                      itemCount: 5,
                      rating: widget.name.grade2.toDouble()),
            )
          ],
        ),
      const SizedBox(height: 20),
      const Text("Commentaires"),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            edit
                ? Expanded(
                    child: TextFormField(
                      controller: commentController,
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: "Commentaires",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.multiline,
                      minLines: 2,
                      maxLines: null,
                    ),
                  )
                : Text(
                    widget.name.comment,
                    style: const TextStyle(fontSize: 16),
                  ),
            IconButton(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.all(0),
                onPressed: (() {
                  if (edit) {
                    widget.name
                        .updateComment(list.uid!, commentController.text);
                  }
                  setState(() => edit = !edit);
                }),
                icon: Icon(edit ? Icons.check : Icons.edit))
          ],
        ),
      ),
    ]);
  }
}
