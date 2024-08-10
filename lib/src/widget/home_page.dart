import 'package:flutter/material.dart';

import 'info_card.dart';
import 'more_card.dart';
import 'state_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _scrollController,
      child: ListView(
        controller: _scrollController,
        children: const <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(12, 12, 12, 6),
            child: StateCard(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 6,
              horizontal: 12,
            ),
            child: InfoCard(),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(12, 6, 12, 12),
            child: MoreCard(),
          ),
        ],
      ),
    );
  }
}
