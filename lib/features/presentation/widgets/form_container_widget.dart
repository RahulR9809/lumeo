
import 'package:flutter/material.dart';
import 'package:lumeo/consts.dart';

class FormContainerWidget extends StatefulWidget {
  final TextEditingController? controller;
  final Key?                fieldKey;
  final bool?               isPasswordField;
  final String?             hintText;
  final String?             labelText;
  final String?             helperText;
  final FormFieldSetter<String>?     onSaved;
  final FormFieldValidator<String>?  validator;
  final ValueChanged<String>?        onFieldSubmitted;
  final TextInputType?               inputType;

  const FormContainerWidget({
    super.key,
    this.controller,
    this.fieldKey,
    this.isPasswordField,
    this.hintText,
    this.labelText,
    this.helperText,
    this.onSaved,
    this.validator,
    this.onFieldSubmitted,
    this.inputType,
  });

  @override
  State<FormContainerWidget> createState() => _FormContainerWidgetState();
}

class _FormContainerWidgetState extends State<FormContainerWidget> {
  bool _obsecureText = true;

  @override
  Widget build(BuildContext context) {
    final width  = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.04,
        vertical  : height * 0.006,
      ),
      decoration: BoxDecoration(
        color: darkGreyColor,
        borderRadius: BorderRadius.circular(width * 0.045), // responsive radius
      ),
      child: TextFormField(
        style        : TextStyle(color: Theme.of(context).colorScheme.surface, fontSize: width * 0.042),
        controller   : widget.controller,
        keyboardType : widget.inputType,
        key          : widget.fieldKey,
        obscureText  : widget.isPasswordField == true ? _obsecureText : false,
        onSaved      : widget.onSaved,
        validator    : widget.validator,
        onFieldSubmitted: widget.onFieldSubmitted,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(width * 0.045),
            borderSide  : BorderSide.none,
          ),
          hintText : widget.hintText,
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.surface,
            fontSize: width * 0.042,
          ),
          suffixIcon: widget.isPasswordField == true
              ? GestureDetector(
                  onTap: () => setState(() => _obsecureText = !_obsecureText),
                  child: Icon(
                    _obsecureText ? Icons.visibility_off : Icons.visibility,
                    color: _obsecureText ? Theme.of(context).colorScheme.secondary : blueColor,
                    size : width * 0.06,
                  ),
                )
              : const SizedBox.shrink(),
          contentPadding: EdgeInsets.symmetric(
            horizontal: width * 0.02,
            vertical  : height * 0.018,
          ),
        ),
      ),
    );
  }
}
