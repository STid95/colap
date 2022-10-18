import 'package:colap/services/database_name.dart';
import 'package:colap/ui/ui.name.details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:colap/models/colap_name.dart';

class UIName extends StatefulWidget {
  final String nameId;
  final String listId;
  final String name;
  const UIName({
    Key? key,
    required this.name,
    required this.nameId,
    required this.listId,
  }) : super(key: key);

  @override
  State<UIName> createState() => _UINameState();
}

class _UINameState extends State<UIName> {
  bool details = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: details
              ? BoxDecoration(
                  border: Border.all(color: Colors.deepPurple, width: 3),
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                )
              : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                  child: Text(
                    widget.name,
                    style: TextStyle(fontSize: details ? 23 : 20),
                  ),
                  onTap: () => setState(() {
                        details = !details;
                      })),
              if (details)
                StreamProvider<ColapName>.value(
                  value: Provider.of<DatabaseNameListService>(context)
                      .getName(widget.listId, widget.nameId),
                  initialData: ColapName(name: ''),
                  builder: (context, child) {
                    ColapName name = Provider.of<ColapName>(context);
                    return UINameDetails(name: name);
                  },
                )
            ],
          ),
        ));
  }
}
