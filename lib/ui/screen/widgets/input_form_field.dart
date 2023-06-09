import 'package:flutter/material.dart';

class InputFormField extends StatelessWidget {
  const InputFormField({
    Key? key,
    this.hintText,
    required this.controller,
    this.isObscure,
    this.maxLines,
    this.validator,
    this.readOnly,
    this.isVisiblePassword,
    this.changeShowPasswordState
  }) : super(key: key);

  final String? hintText;
  final TextEditingController controller;
  final bool? isObscure;
  final int? maxLines;
  final bool? readOnly;
  final IconData? isVisiblePassword;
  final VoidCallback? changeShowPasswordState;

  final Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines ?? 1,
      controller: controller,
      obscureText: isObscure ?? false,
      readOnly: readOnly ?? false,
      validator: (value) {
        if (validator != null) {
          return validator!(value);
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
        suffixIcon: IconButton(
          onPressed: changeShowPasswordState,
          icon: Icon(isVisiblePassword),
        ),
        suffixIconColor: Colors.grey,
        fillColor: Colors.white,
        hintText: hintText,
        filled: true,
        border: const OutlineInputBorder(borderSide: BorderSide.none),
      ),
    );
  }
}
