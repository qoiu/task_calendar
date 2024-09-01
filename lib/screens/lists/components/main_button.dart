import 'package:flutter/material.dart';

import '../../../utils/utils.dart';

class MainButton extends StatelessWidget {
  final Function() onClick;
  final String text;
  final bool isLoading;
  final bool isActive;
  final Color? color;
  final Color? textColor;
  final Widget? extraRight;
  final Color? border;
  final bool filled;

  const MainButton(this.text, this.onClick,
      {this.isLoading = false,
      this.isActive = true,
      this.color,
      this.textColor,
      this.border,
      this.extraRight,
      this.filled = false,
      super.key});

  MainButton.secondary(this.text, this.onClick,
      {this.isLoading = false,
      this.isActive = true,
      this.extraRight,
      this.border,
      this.filled = false,
      super.key})
      : color = getColorScheme().secondary,
        textColor = getColorScheme().onSecondary;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Material(
        borderRadius: BorderRadius.circular(15),
        color: color ?? Colors.transparent,
        child: Opacity(
          opacity: isActive ? 1 : 0.4,
          child: InkWell(
            highlightColor: Colors.white.withAlpha(30),
            onTap: isActive && !isLoading
                ? () {
                    onClick();
                  }
                : null,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: getColorScheme().primary)),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (filled) ...{
                    const Expanded(
                        child: SizedBox(
                      height: 0,
                    ))
                  },
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Opacity(
                        opacity: isLoading ? 0 : 1,
                        child: Text(
                          text,
                          maxLines: 2,
                          style: getTextStyle().titleMedium?.copyWith(
                              color: textColor ?? getColorScheme().primary),
                        ),
                      ),
                      if (isLoading) ...{
                        SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: textColor ?? getColorScheme().primary,
                          ),
                        )
                      }
                    ],
                  ),
                  if (extraRight != null) ...{
                    const SizedBox(
                      width: 10,
                    ),
                    extraRight!
                  },
                  if (filled) ...{
                    const Expanded(
                        child: SizedBox(
                      height: 0,
                    ))
                  },
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
