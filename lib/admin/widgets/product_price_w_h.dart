import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProductPriceWH extends StatelessWidget {
  final TextEditingController controller;
  final String labelTxt;
  final int? maxLen;

  const ProductPriceWH({super.key, required this.controller, required this.labelTxt , this.maxLen});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      cursorColor: Colors.white,
      maxLines: 1,
      minLines: 1,
      maxLength: maxLen ?? 3,
      decoration: InputDecoration(
        labelStyle: const TextStyle(color: Colors.white),
        labelText: labelTxt,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Colors.grey, width: 1),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Colors.grey, width: 1),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Colors.grey, width: 1),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (value) {
        if (value!.isEmpty) {
          return "enter a value";
        }
        return null;
      },
    );
  }
}
