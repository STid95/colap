import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import 'package:colap/models/colap_list.dart';

import '../models/colap_name.dart';

class UICreationName extends StatefulWidget {
  final Function(ColapName) onValidate;
  final String userName;

  const UICreationName({
    Key? key,
    required this.onValidate,
    required this.userName,
  }) : super(key: key);

  @override
  State<UICreationName> createState() => _UICreationNameState();
}

class _UICreationNameState extends State<UICreationName> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final commentController = TextEditingController();
  bool nameValidated = false;
  bool commentValidated = false;
  int grade1 = 0;
  int grade2 = 0;
  @override
  Widget build(BuildContext context) {
    final list = Provider.of<ColapList>(context, listen: false);
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: SizedBox(
        height: 350,
        child: Card(
          shadowColor: Colors.purple,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      nameValidated
                          ? Text(
                              nameController.text,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )
                          : Expanded(
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  hintText: "Prénom",
                                ),
                                controller: nameController,
                                keyboardType: TextInputType.name,
                                autofocus: true,
                                enableSuggestions: false,
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? "Entrez un prénom"
                                        : null,
                              ),
                            ),
                      IconButton(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.all(0),
                          onPressed: (() =>
                              setState(() => nameValidated = !nameValidated)),
                          icon: Icon(nameValidated ? Icons.edit : Icons.check))
                    ],
                  ),
                  RatingBar.builder(
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.purpleAccent,
                          ),
                      onRatingUpdate: (rating) {
                        if (widget.userName == list.user1) {
                          print("coucou");
                          grade1 = rating.toInt();
                        } else {
                          grade2 = rating.toInt();
                        }
                      }),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: "Commentaires",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.multiline,
                    minLines: 3,
                    maxLines: null,
                    controller: commentController,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() == true) {
                          widget.onValidate(ColapName(
                              name: nameController.text,
                              grade1: grade1,
                              grade2: grade2,
                              comment: commentController.text));
                        }
                      },
                      child: const Text("OK"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
