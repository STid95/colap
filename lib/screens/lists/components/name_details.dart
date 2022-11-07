import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import 'package:colap/models/colap_list.dart';
import 'package:colap/models/colap_name.dart';

import '../../../models/colap_user.dart';
import 'user_grade.dart';

class NameDetails extends StatefulWidget {
  final void Function() onDelete;
  final ColapName name;
  const NameDetails({
    Key? key,
    required this.name,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<NameDetails> createState() => _NameDetailsState();
}

class _NameDetailsState extends State<NameDetails> {
  bool edit = false;
  @override
  Widget build(BuildContext context) {
    final TextEditingController commentController =
        TextEditingController(text: widget.name.comment);
    final list = Provider.of<ColapList>(context, listen: false);
    final user = Provider.of<ColapUser>(context);
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          Text(widget.name.name, style: Theme.of(context).textTheme.headline1)
        ]),
        const SizedBox(height: 10),
        Hero(
          tag: widget.name.uid ?? '',
          child: RatingBarIndicator(
              itemSize: 50,
              itemBuilder: (context, _) => const Icon(Icons.star),
              itemCount: 5,
              rating: widget.name.averageGrade.toDouble()),
        ),
        const SizedBox(height: 20),
        Column(
            children: list.users
                .map((e) => UserGrade(
                      list: list,
                      currentUser: user,
                      widget: widget,
                      userGrade: e,
                    ))
                .toList()),
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
