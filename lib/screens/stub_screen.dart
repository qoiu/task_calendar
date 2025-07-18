import 'package:flutter/material.dart';
import 'package:qoiu_utils/components/common_text_builder.dart';

class StubScreen extends StatelessWidget {
  final String text;
  const StubScreen(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextBuilder(text).build(),
    );
  }
}
