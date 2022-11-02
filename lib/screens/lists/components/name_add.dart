import 'package:colap/commons/ui.commons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:colap/models/colap_list.dart';

import '../../../models/colap_name.dart';

class AddName extends StatefulWidget {
  final void Function() onCancel;
  final Function(ColapName) onValidate;
  final String userName;

  const AddName({
    Key? key,
    required this.onValidate,
    required this.userName,
    required this.onCancel,
  }) : super(key: key);

  @override
  State<AddName> createState() => _AddNameState();
}

class _AddNameState extends State<AddName> {
  bool loading = false;
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
        height: 400,
        child: loading
            ? circularProgress()
            : Card(
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
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
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
                                onPressed: (() => setState(
                                    () => nameValidated = !nameValidated)),
                                icon: Icon(
                                    nameValidated ? Icons.edit : Icons.check))
                          ],
                        ),
                        UIRating(
                            itemSize: MediaQuery.of(context).size.width * 0.10,
                            initialRating: 0,
                            onUpdate: (rating) {
                              if (widget.userName == list.users[0]) {
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
                        Center(
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            runAlignment: WrapAlignment.center,
                            spacing: 20,
                            runSpacing: 20,
                            children: [
                              ColapIconButton(
                                icon: Icons.check_circle_outline,
                                onPressed: () {
                                  if (_formKey.currentState?.validate() ==
                                      true) {
                                    addName();
                                  }
                                },
                                text: "OK",
                              ),
                              ColapIconButton(
                                icon: Icons.cancel_presentation,
                                onPressed: () {
                                  widget.onCancel();
                                },
                                text: "Annuler",
                              ),
                            ],
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

  void addName() {
    setState(() {
      loading = true;
    });
    widget.onValidate(ColapName(
        name: nameController.text,
        grade1: grade1,
        grade2: grade2,
        comment: commentController.text,
        averageGrade: grade1 != 0
            ? grade1
            : grade2 != 0
                ? grade2
                : 0));
    setState(() {
      loading = false;
    });
  }
}
