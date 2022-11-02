import 'package:flutter/material.dart';

import '../../../services/database_list.dart';

class DropdownOrder extends StatelessWidget {
  final Function(OrderBy) onChanged;
  const DropdownOrder({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButton<OrderBy>(
        underline: Container(),
        icon: const Icon(
          Icons.sort,
          size: 30,
        ),
        items: OrderBy.values.map<DropdownMenuItem<OrderBy>>((OrderBy choice) {
          return DropdownMenuItem<OrderBy>(
            value: choice,
            child: Text(choice.displayName),
          );
        }).toList(),
        onChanged: (OrderBy? choice) {
          if (choice != null) {
            onChanged(choice);
          }
        });
  }
}
