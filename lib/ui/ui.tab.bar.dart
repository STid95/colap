import 'package:colap/ui/ui.list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/colap_list.dart';

class ColapTabBar extends StatefulWidget {
  final String? createdListId;
  final List<ColapList> lists;
  const ColapTabBar({
    Key? key,
    required this.lists,
    this.createdListId,
  }) : super(key: key);

  @override
  State<ColapTabBar> createState() => _ColapTabBarState();
}

class _ColapTabBarState extends State<ColapTabBar>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
        initialIndex: widget.createdListId != null
            ? widget.lists.indexOf(widget.lists
                .firstWhere((element) => element.uid == widget.createdListId))
            : 0,
        length: widget.lists.length,
        vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _tabController = TabController(
        initialIndex: widget.createdListId != null
            ? widget.lists.indexOf(widget.lists
                .firstWhere((element) => element.uid == widget.createdListId))
            : 0,
        length: widget.lists.length,
        vsync: this);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        TabBar(
          isScrollable: true,
          indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(80), // Creates border
              color: Theme.of(context).colorScheme.secondary),
          tabs: widget.lists
              .map((e) => Tab(
                    child: Text(
                      e.title,
                      style: Theme.of(context).textTheme.headline2,
                    ),
                  ))
              .toList(),
          controller: _tabController,
        ),
        Expanded(
            child: TabBarView(
                controller: _tabController,
                children: widget.lists
                    .map((e) => Provider(
                        create: (context) => ColapList(
                            title: e.title, uid: e.uid, users: e.users),
                        builder: ((context, child) => UIColapList(
                              list: e,
                              onListDeleted: () {
                                _tabController = TabController(
                                    length: widget.lists.length, vsync: this);
                              },
                            ))))
                    .toList()))
      ]),
    );
  }
}
