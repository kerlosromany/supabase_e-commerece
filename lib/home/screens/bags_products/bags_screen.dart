import 'package:flutter/material.dart';
import '../../../core/consts/app_calculates.dart';
import '../../../core/widgets/info_widget.dart';
import 'bags_products_screen.dart';
import '../../widgets/main_widget.dart';


class BagsScreen extends StatelessWidget {
  const BagsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xff232531),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  MainWidget(
                    imgPathP: "assets/default.jpeg",
                    titleP: "شنط مصري",
                    subTitleP: "يوجد 8 مقاسات",
                    fun: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const BagsProductsScreen(bagsType: "masry",)));
                    },
                  ),
                   SizedBox(height: SizeHelper.h10),
                  MainWidget(
                    imgPathP: "assets/default.jpeg",
                    titleP: "شنط مستورد",
                    subTitleP: "يوجد 5 مقاسات",
                    fun: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const BagsProductsScreen(bagsType: "locs",)));
                    },
                  ),
                   SizedBox(height: SizeHelper.h10),
                  MainWidget(
                    imgPathP: "assets/default.jpeg",
                    titleP: "شنط بوكس",
                    subTitleP: "يوجد 4 مقاسات",
                    fun: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const BagsProductsScreen(bagsType: "box",)));
                    },
                  ),
                   SizedBox(height: SizeHelper.h20),
                  const InfoWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
