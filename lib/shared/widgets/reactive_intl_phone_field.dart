import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:reactive_forms/reactive_forms.dart';

class ReactiveIntlPhoneField extends StatelessWidget {
  const ReactiveIntlPhoneField({
    required this.formControl,
    this.invalidNumberMessage,
    super.key,
  });
  final FormControl<String> formControl;
  final String? invalidNumberMessage;
  @override
  Widget build(BuildContext context) {
    return ReactiveFormConsumer(
      builder: (context, form, _) {
        return IntlPhoneField(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          invalidNumberMessage: invalidNumberMessage,
          initialValue: formControl.value,
          onChanged: (value) => formControl.value = value.completeNumber,
        );
      },
    );
  }
}
