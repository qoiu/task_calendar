import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task_calendar/utils/utils.dart';

class CommonTextField extends StatelessWidget {
  final String? hint;
  final TextEditingController? controller;
  final Function(String)? onSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final String? title;
  final bool enabled;
  final Function()? onCLick;
  final Function(PointerDownEvent)? onTapOutside;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization = TextCapitalization.sentences;
  final TextAlign textAlign;
  final int? minLines;
  final int maxLines;
  final int? maxLength;
  final FocusNode? focusNode;
  final EdgeInsets contentPadding;
  final String? textSuffix;
  final bool notifyIfEmpty;
  final bool isLoading;
  final bool obscure;
  final TextInputAction? textInputAction;
  final bool Function()? notifyCondition;
  final Widget? suffix;
  final bool isCorrect;

  const CommonTextField(
      {super.key,
      this.onSubmitted,
      this.hint,
      this.inputFormatters,
      this.controller,
      this.title,
      this.enabled = true,
      this.onCLick,
      this.onTapOutside,
      this.keyboardType,
      this.minLines,
      this.maxLines = 1,
      this.textAlign = TextAlign.left,
      this.maxLength,
      this.textSuffix,
      this.focusNode,
      this.notifyCondition,
      this.notifyIfEmpty = false,
      this.isLoading = false,
      this.obscure = false,
      this.textInputAction,
      this.suffix,
      this.isCorrect = true,
      this.contentPadding =
          const EdgeInsets.symmetric(horizontal: 10, vertical: 15)});

  static InputBorder outlineInputBorder(bool isCorrect) => OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(5)),
      borderSide: BorderSide(
          color: getColorScheme().onPrimary));

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      title != null
          ? Text(
              title!,
              style: getTextStyle().bodyLarge?.copyWith(
                  color:  getColorScheme().onPrimary),
              textAlign: TextAlign.start,
            )
          : Container(),
      title != null
          ? const SizedBox(
              height: 5,
            )
          : Container(),
      Stack(
        children: [
          TextField(
            onSubmitted: onSubmitted,
            onChanged: onSubmitted,
            onTapOutside: onTapOutside,
            keyboardType: keyboardType,
            textCapitalization: textCapitalization,
            focusNode: focusNode,
            maxLength: maxLength,
            obscureText: obscure,
            textAlign: textAlign,
            textInputAction: textInputAction,
            decoration: InputDecoration(
              border: outlineInputBorder(isCorrect),
              disabledBorder: outlineInputBorder(isCorrect),
              enabledBorder: outlineInputBorder(isCorrect),
              focusedBorder: outlineInputBorder(isCorrect),
              counterText: "",
              focusColor: null,
              hoverColor: null,
              suffixText: textSuffix,
              suffixStyle: getTextStyle().bodyMedium,
              fillColor: null,
              isDense: true,
              suffix: suffix != null ? const SizedBox(width: 30) : null,
              hintStyle: getTextStyle()
                  .bodySmall
                  ?.copyWith(color: getColorScheme().onSurface),
              hintText: hint,
              contentPadding: contentPadding,
            ),
            readOnly: !enabled,
            onTap: onCLick,
            style: getTextStyle().bodyMedium,
            inputFormatters: inputFormatters,
            controller: controller,
            minLines: minLines,
            maxLines: maxLines,
          ),
          Container(
              alignment: AlignmentDirectional.centerEnd,
              padding: const EdgeInsets.only(right: 10, top: 8),
              child: isLoading
                  ? const SizedBox(
                      width: 20, height: 20, child: CircularProgressIndicator())
                  : suffix),
          if ((notifyCondition != null && notifyCondition!()) ||
              (notifyIfEmpty && controller?.text.isEmpty == true)) ...{
            Transform(
                transform:
                    Transform.translate(offset: const Offset(5, 5)).transform,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: getColorScheme().onPrimary,
                  ),
                )),
          }
        ],
      )
    ]);
  }
}
