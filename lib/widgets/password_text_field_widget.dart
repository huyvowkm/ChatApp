import 'dart:core';
import 'package:flutter/material.dart';

class PasswordTextFieldWidget extends StatefulWidget {
  bool obscureText = true;
  String obscuringCharacter = '•';
  String? initialValue;
  TextEditingController? controller;
  String? Function(String?)? validator;
  AutovalidateMode? autovalidateMode;
  TextStyle? style;
  TextDirection? textDirection;
  TextAlign textAlign;
  bool readOnly;
  bool expands;
  int? maxLength;
  Text label;
  InputDecoration decoration = const InputDecoration();

  PasswordTextFieldWidget({
    super.key, 
    this.initialValue,
    this.controller, 
    this.validator, 
    this.autovalidateMode,
    this.style,
    this.textDirection,
    this.textAlign = TextAlign.start,
    this.readOnly = false,
    this.maxLength,
    this.expands = false,
    this.label = const Text(''),
  });

  @override
  State<PasswordTextFieldWidget> createState() => _PasswordTextFieldWidgetState();
}

class _PasswordTextFieldWidgetState extends State<PasswordTextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    IconButton showhide = IconButton(
      icon: Icon(widget.obscureText ? Icons.visibility_off : Icons.visibility),
      onPressed: () {
        setState(() {
          widget.obscureText = !widget.obscureText;
        });
      }
    );
    widget.decoration = InputDecoration(
      label: widget.label,
      hintText : "Enter your password...",
      suffixIcon: showhide,
      border: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1,
          color: Colors.white,
        ),
        borderRadius: BorderRadius.circular(15),
      )
    );

    return TextFormField(
      initialValue: widget.initialValue,
      obscureText: widget.obscureText,
      controller: widget.controller,
      validator: widget.validator,
      autovalidateMode: widget.autovalidateMode,
      style: widget.style,
      decoration: widget.decoration,
      textDirection: widget.textDirection,
      textAlign: widget.textAlign,
      readOnly: widget.readOnly,
      maxLength: widget.maxLength,
      expands: widget.expands,
    );
  }
}