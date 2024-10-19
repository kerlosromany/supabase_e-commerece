import 'package:flutter/material.dart';

class AreaFormField extends StatelessWidget {
  final TextEditingController controller;
  final bool isVisible;
  const AreaFormField({super.key, required this.controller, required this.isVisible});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      cursorColor: Colors.white,
      maxLines: 2,
      minLines: 1,
      decoration: const InputDecoration(
        labelStyle: TextStyle(color: Colors.white),
        labelText: 'المنطقة',
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
      keyboardType: TextInputType.text,
      validator: (value) {
        if (isVisible && value!.isEmpty) {
          return "قم بادخال اسم المنطقة";
        }
        return null;
      },
    );
  }
}
