import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qoiu_utils/qoiu_utils.dart';
import 'package:qoiu_utils/qoiu_utils.dart';

class CommonFormField extends StatefulWidget {
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? hint;
  final Function(String)? onSubmitted;
  final Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final String? title;
  final bool enabled;
  final bool obscure;
  final FocusNode? focusNode;
  final Function()? onCLick;
  final Function(PointerDownEvent)? onTapOutside;
  final TextCapitalization textCapitalization = TextCapitalization.sentences;
  final TextAlign textAlign;
  final int? minLines;
  final int maxLines;
  final int? maxLength;
  final EdgeInsets contentPadding;
  final Widget? leftIcon;
  final Widget? rightIcon;
  final String? textSuffix;
  final bool notifyIfEmpty;
  final bool Function()? notifyCondition;

  const CommonFormField(
      {this.controller,
      this.keyboardType,
      super.key,
      this.hint,
      this.onSubmitted,
      this.onChanged,
      this.inputFormatters,
      this.title,
      this.enabled=true,
      this.obscure=false,
      this.focusNode,
      this.onCLick,
      this.onTapOutside,
      this.textAlign = TextAlign.left,
      this.minLines,
      this.maxLines=1,
      this.maxLength,
      this.contentPadding = const EdgeInsets.all(5),
      this.leftIcon,
      this.rightIcon,
      this.textSuffix,
      this.notifyIfEmpty=true,
      this.notifyCondition});

  @override
  State<CommonFormField> createState() => _CommonFormFieldState();
}

class _CommonFormFieldState extends State<CommonFormField> {
  static OutlineInputBorder border = OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(color: getColorScheme().outline));

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      style: getTextStyle().bodyMedium,
      keyboardType: widget.keyboardType ?? TextInputType.text,
      enableInteractiveSelection: true,
      readOnly: !widget.enabled,
      onTap: widget.onCLick,
      inputFormatters: widget.inputFormatters,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      onTapOutside: widget.onTapOutside,
      textCapitalization: widget.textCapitalization,
      focusNode: widget.focusNode,
      maxLength: widget.maxLength,
      obscureText: widget.obscure,
      textAlign: widget.textAlign,
      onChanged: (s) {
        setState(() {});
        if(widget.onChanged!=null) {
          widget.onChanged!(s);
        }
      },
      decoration: InputDecoration(
          labelText: widget.controller?.text.isEmpty == true ? null : widget.hint,
          labelStyle: getTextStyle().bodySmall,
          // suffixText: suffixText ?? '',
          border: border,
          hintText: widget.hint,
          suffixIcon: widget.rightIcon,
          suffixText: widget.textSuffix,
          hintStyle: getTextStyle().bodySmall?.copyWith(color: Colors.grey),
          floatingLabelBehavior: FloatingLabelBehavior.always),
      validator: (value) {
        // if (value?.isEmpty==true) {
        //   return 'Please enter some text';
        // }
        return null;
      },
      // onChanged: (String text) => onChange(text),
    );
  }
}
