import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../constants/constants.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    Key key,
    this.initialvalue,
    this.hint,
    this.isprice = false,
    this.onsaved,
    this.validator,
  }) : super(key: key);
  final String initialvalue;
  final String hint;
  final bool isprice;
  final void Function(String) onsaved;
  final String Function(String) validator;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40,
      child: TextFormField(
        initialValue: initialvalue,
        maxLines: 1,
        maxLength: 50,
        maxLengthEnforcement: MaxLengthEnforcement.none,
        keyboardType: isprice ? TextInputType.number : TextInputType.text,
        style: Theme.of(context).textTheme.subtitle1,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(0.0),
          hintText: hint,
          prefixIcon: Icon(
            Icons.edit,
            size: 24,
            color: Theme.of(context).cardColor,
          ),
          counterText: '',
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(MConstants.bigborderRadius),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(MConstants.bigborderRadius),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(MConstants.bigborderRadius),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(MConstants.bigborderRadius),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
        ),
        validator: validator,
        onSaved: onsaved,
      ),
    );
  }
}
