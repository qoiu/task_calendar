import 'package:flutter/material.dart';
import 'package:qoiu_utils/components/common_text_builder.dart';
import 'package:qoiu_utils/qoiu_utills.dart';

class MenuButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const MenuButton({super.key,required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    var borderRadius = BorderRadius.circular(10);
    return Material(
      borderRadius: borderRadius,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: onTap,
        child: Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            border: Border.all(color: getColorScheme().outline)
          ),
          padding: const EdgeInsets.all(10),
          alignment: Alignment.center,
          child: TextBuilder(title).titleMedium().build(),
        ),
      ),
    );
  }
}
