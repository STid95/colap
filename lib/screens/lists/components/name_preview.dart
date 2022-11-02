import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import 'package:colap/models/colap_name.dart';
import 'package:colap/services/database_name.dart';
import 'package:colap/screens/lists/components/name_details.dart';

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
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.name,
                      style: Theme.of(context).textTheme.headline5,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                  Hero(
                    tag: widget.nameId,
                    child: RatingBarIndicator(
                        itemSize: 35,
                        itemBuilder: (context, _) => const Icon(Icons.star),
                        itemCount: 5,
                        rating: widget.averageGrade.toDouble()),
                  ),
                ],
              ),
        onTap: () => setState(() {
          details = !details;
        }),
      ),
    );
  }
}
