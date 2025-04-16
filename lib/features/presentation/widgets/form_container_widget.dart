import 'package:flutter/material.dart';
import 'package:lumeo/consts.dart';

class FormContainerWidget extends StatefulWidget {
  final TextEditingController? controller;
  final Key? fieldKey;
  final bool? isPasswordField;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputType? inputType;
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
  bool _obsecureText=true;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: darkGreyColor,borderRadius:BorderRadius.circular(3)
      ),
      child: TextFormField(  
        style: const TextStyle(color:whiteColor ),
        controller: widget.controller,
        keyboardType: widget.inputType,
        key: widget.fieldKey,
        obscureText: widget.isPasswordField==true ? _obsecureText :false,
      onSaved: widget.onSaved,
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: widget.hintText,
        hintStyle: const TextStyle(
          color: whiteColor, 
          
        ),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _obsecureText = !_obsecureText;
            });
          },
          child:  widget.isPasswordField==true ? Icon(
            _obsecureText ? Icons.visibility_off :Icons.visibility,
            color: _obsecureText ==false ?blueColor : secondaryColor,
          ) :const Text(" ")
        )
      ),
      ),
    );
  }
}
