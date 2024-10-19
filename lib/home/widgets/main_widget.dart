import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class MainWidget extends StatelessWidget {
  final String imgPathP;
  final String titleP;
  final String subTitleP;
  final Function fun;
  final int? maxLen ;
  const MainWidget({
    super.key,
    required this.imgPathP,
    required this.titleP,
    required this.subTitleP,
    required this.fun, this.maxLen,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        fun();
      },
      child: Container(
        height: screenHeight * 0.27,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: screenWidth * 0.6,
              height: screenHeight * 0.27,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
                image: DecorationImage(
                  image: AssetImage(imgPathP),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AutoSizeText(
                      titleP,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w900),
                      maxLines: maxLen ?? 1,
                      textAlign: TextAlign.end,
                    ),
                    AutoSizeText(
                      subTitleP,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                      maxLines: 3,
                      textAlign: TextAlign.end,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
