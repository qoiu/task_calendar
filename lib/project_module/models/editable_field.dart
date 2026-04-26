import 'package:flutter/material.dart';
import 'package:qoiu_utils/qoiu_utils.dart';

class EditableField {
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();
  bool isEdit = false;
  Function(String)? onChange;
  Function(String)? onDone;

  clear() {
    onDone?.let((e) => e(controller.text));
    controller.text = '';
    onChange = null;
    onDone = null;
  }

  setup(
      {required String text,
      Function(String)? onChange,
      Function(String)? onDone}) {
    isEdit = true;
    controller.text = text;
    this.onChange = onChange;
    this.onDone = onDone;
  }
}
