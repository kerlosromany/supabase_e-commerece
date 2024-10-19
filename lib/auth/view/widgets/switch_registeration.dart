import 'package:flutter/material.dart';

class SwitchRegisteration extends StatelessWidget {
  const SwitchRegisteration({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "سجل دخول الان",
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text("\t\tلديك حساب بالفعل؟"),
      ],
    );
  }
}
