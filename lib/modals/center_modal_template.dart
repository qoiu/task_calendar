import 'package:flutter/material.dart';
import 'package:qoiu_utils/components/common_text_builder.dart';
import 'package:qoiu_utils/qoiu_utills.dart';

class CenterModalTemplate extends StatelessWidget {
  final Widget child;
  final String? tag;
  final String title;
  final Widget? titleWidget;
  final Color? color;
  final EdgeInsets? padding;
  final bool simpleChild;

  const CenterModalTemplate(this.child,
      {this.tag,
      this.color,
      this.title = "",
      this.simpleChild = false,
      this.padding,
      super.key})
      : titleWidget = null;

  const CenterModalTemplate.widget(
      {super.key,
      required this.child,
      required this.tag,
      this.titleWidget,
      this.color,
      this.simpleChild = false,
      this.padding})
      : title = "";

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(25);
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          color: Colors.black.withAlpha(100),
          alignment: Alignment.center,
          child: IntrinsicHeight(
            child: IntrinsicWidth(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: borderRadius,
                    color: color ?? getColorScheme().surface),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if(title.isNotEmpty)...{
                      Padding(padding: const EdgeInsets.symmetric(horizontal: 20),child:TextBuilder(title).titleMedium().build()),
                      const SizedBox(height: 20),
                    },
                    simpleChild
                        ? Padding(
                          padding: padding ?? const EdgeInsets.all(0),
                          child: child,
                        )
                        : IntrinsicHeight(
                            child: Padding(
                          padding: padding ??
                              const EdgeInsets.only(
                                  bottom: 20, left: 20, right: 20),
                          child: child,
                        ))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
