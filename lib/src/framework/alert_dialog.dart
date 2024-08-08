import 'package:flutter/material.dart';

import 'context_wrapper.dart';

final class EAlertDialogBuilder {
  EAlertDialogBuilder({required this.build});

  final ContextWrapper build;

  late String _title;

  void setTitle(String title) {
    _title = title;
  }

  void setItem(Widget item) {}

  EAlertDialog create() {
    return EAlertDialog(title: _title);
  }
}

class EAlertDialog {
  EAlertDialog({required this.title});

  final String title;

  void show() {}

  void hide() {}
}
