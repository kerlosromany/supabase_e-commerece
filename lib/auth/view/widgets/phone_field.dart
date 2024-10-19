import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneTextField extends StatelessWidget {
  final TextEditingController controller;
  const PhoneTextField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      cursorColor: Colors.white,
      maxLines: 1,
      minLines: 1,
      maxLength: 11,
      decoration: const InputDecoration(
        labelStyle: TextStyle(color: Colors.white),
        labelText: 'رقم التليفون',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Colors.grey, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Colors.grey, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Colors.grey, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
      ),
      keyboardType: TextInputType.phone,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (value) {
        if (value!.isEmpty) {
          return "قم بادخال رقم الموبايل";
        }
        if (value.length != 11) {
          return "رقم الموبايل يجب ان يكون 11 رقم";
        }
        return null;
      },
    );
  }
}
