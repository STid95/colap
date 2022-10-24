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
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
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
          Text(widget.name.name, style: Theme.of(context).textTheme.headline1)
        ]),
        const SizedBox(height: 10),
        Hero(
          tag: widget.name.name,
          child: RatingBarIndicator(
              itemSize: 50,
              itemBuilder: (context, _) => const Icon(Icons.star),
              itemCount: 5,
              rating: widget.name.averageGrade.toDouble()),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                list.users[0],
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
                width: 150,
                child: user.name == list.users[0]
                    ? UIRating(
                        itemSize: 25,
                        initialRating: widget.name.grade1.toDouble(),
                        onUpdate: (rating) {
                          widget.name.grade1 = rating.toInt();
                          widget.name.updateRating1(list.uid!);
                        })
                    : RatingBarIndicator(
                        itemSize: 25,
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 2.0),
                        itemBuilder: (context, _) => const Icon(Icons.star),
                        itemCount: 5,
                        rating: widget.name.grade1.toDouble())),
          ],
        ),
        if (list.users.length > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  list.users[1],
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 150,
                child: user.name == list.users[1]
                    ? UIRating(
                        itemSize: 25,
                        initialRating: widget.name.grade2.toDouble(),
                        onUpdate: (rating) {
                          widget.name.grade2 = rating.toInt();
                          widget.name.updateRating2(list.uid!);
                        })
                    : RatingBarIndicator(
                        itemSize: 25,
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 2.0),
                        itemBuilder: (context, _) => const Icon(Icons.star),
                        itemCount: 5,
                        rating: widget.name.grade2.toDouble()),
              )
            ],
          ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              edit
                  ? Expanded(
                      child: TextFormField(
                        controller: commentController,
                        autofocus: true,
                        scrollPadding: const EdgeInsets.only(bottom: 60),
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
                      style: Theme.of(context).textTheme.bodyText1,
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
      ]),
    );
  }
}
