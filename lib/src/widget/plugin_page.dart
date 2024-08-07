import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodel/manager_view_model.dart';
import 'plugin_card.dart';

class PluginPage extends StatefulWidget {
  const PluginPage({super.key});

  @override
  State<PluginPage> createState() => _PluginPageState();
}

class _PluginPageState extends State<PluginPage> {
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
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: Consumer<ManagerViewModel>(
              builder: (context, viewModel, child) => ListBody(
                children: viewModel.getPluginDetailsList
                    .map(
                      (element) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Builder(
                          builder: (context) => PluginCard(
                            details: element,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
