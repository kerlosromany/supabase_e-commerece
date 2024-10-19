import 'package:flutter/material.dart';

class AuthText extends StatelessWidget {
  final String txt;
  const AuthText({super.key, required this.txt});

  @override
  Widget build(BuildContext context) {
    return Text(
      txt,
      style: const TextStyle(
          fontSize: 34, fontWeight: FontWeight.bold, color: Colors.white),
    );
  }
}
