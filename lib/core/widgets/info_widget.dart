import 'package:flutter/material.dart';

class InfoWidget extends StatelessWidget {
  const InfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      "كل فترة سيتم اضافة انواع اخري من البضائع",
      style: TextStyle(
        color: Colors.red,
        fontSize: 30,
        fontWeight: FontWeight.w800,
      ),
      textAlign: TextAlign.center,
    );
  }
}
