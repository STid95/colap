import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import 'package:colap/models/colap_name.dart';
import 'package:colap/services/database_name.dart';
import 'package:colap/screens/lists/components/name_details.dart';

import 'dialogs/remove_dialog.dart';

class NamePreview extends StatefulWidget {
  final String nameId;
  final String listId;
  final String name;
  final num averageGrade;
  const NamePreview({
    Key? key,
    required this.nameId,
    required this.listId,
    required this.name,
    required this.averageGrade,
  }) : super(key: key);

  @override
  State<NamePreview> createState() => _NamePreviewState();
}

class _NamePreviewState extends State<NamePreview> {
  bool details = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: GestureDetector(
        child: details
            ? Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      StreamProvider<ColapName>.value(
                        value: Provider.of<DatabaseNameListService>(context)
                            .getName(widget.listId, widget.nameId),
                        initialData: ColapName(name: ''),
                        builder: (context, child) {
                          ColapName name = Provider.of<ColapName>(context);
                          return NameDetails(
                            name: name,
                            onDelete: () => setState(() {
                              details = false;
                            }),
                          );
                        },
                      )
                    ],
                  ),
                ),
              )
            : ListTile(
                contentPadding: EdgeInsets.zero,
                horizontalTitleGap: 0,
                title: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Text(
                    widget.name,
                    style: Theme.of(context).textTheme.headline5,
                    overflow: TextOverflow.clip,
                  ),
                ),
                leading: InkWell(
                    child: Icon(Icons.delete,
                        size: 20, color: Theme.of(context).colorScheme.primary),
                    onTap: () => showRemoveDialog(context, (() {
                          setState(() {
                            details = false;
                          });
                          ColapName(name: widget.name, uid: widget.nameId)
                              .remove(widget.listId);
                        }))),
                trailing: Hero(
                  tag: widget.nameId,
                  child: RatingBarIndicator(
                      itemSize: 30,
                      itemBuilder: (context, _) => Icon(Icons.star,
                          color: Theme.of(context).colorScheme.primary),
                      itemCount: 5,
                      rating: widget.averageGrade.toDouble()),
                ),
              ),
        onTap: () => setState(() {
          details = !details;
        }),
      ),
    );
  }
}
