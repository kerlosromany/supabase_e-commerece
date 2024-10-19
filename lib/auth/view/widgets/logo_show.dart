import 'package:flutter/material.dart';

class LogoShow extends StatelessWidget {
  const LogoShow({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth * 0.5,
      height: screenWidth * 0.5,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
            image: AssetImage(
              "assets/logo.jpg",
            ),
            fit: BoxFit.fill),
      ),
    );
  }
}
