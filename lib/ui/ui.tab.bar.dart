import 'package:colap/ui/ui.list.dart';
import 'package:flutter/material.dart';

import '../models/colap_list.dart';

class ColapTabBar extends StatefulWidget {
  final List<ColapList> lists;
  const ColapTabBar({
    Key? key,
    required this.lists,
  }) : super(key: key);

  @override
  State<ColapTabBar> createState() => _ColapTabBarState();
}

class _ColapTabBarState extends State<ColapTabBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: widget.lists.length, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        TabBar(
          isScrollable: true,
          indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(80), // Creates border
              color: const Color.fromARGB(255, 193, 172, 230)),
          tabs: widget.lists
              .map((e) => Tab(
                    child: Text(
                      e.title,
                      style: const TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ))
              .toList(),
          controller: _tabController,
        ),
        Expanded(
            child: TabBarView(
                controller: _tabController,
                children:
                    widget.lists.map((e) => UIColapList(list: e)).toList()))
      ]),
    );
  }
}
