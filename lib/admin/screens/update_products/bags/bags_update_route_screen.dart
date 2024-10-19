import 'package:flutter/material.dart';
import 'update_bags_screen.dart';
import '../../../../core/widgets/info_widget.dart';
import '../../../../home/widgets/main_widget.dart';


class BagsUpdateRouteScreen extends StatelessWidget {
  const BagsUpdateRouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xff232531),
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const UpdateBagsScreen(bagsType: "masry",)));
                    },
                  ),
                  const SizedBox(height: 10),
                  MainWidget(
                    imgPathP: "assets/default.jpeg",
                    titleP: "شنط مستورد",
                    subTitleP: "يوجد 5 مقاسات",
                    fun: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const UpdateBagsScreen(bagsType: "locs",)));
                    },
                  ),
                  const SizedBox(height: 10),
                  MainWidget(
                    imgPathP: "assets/default.jpeg",
                    titleP: "شنط بوكس",
                    subTitleP: "يوجد 4 مقاسات",
                    fun: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const UpdateBagsScreen(bagsType: "box",)));
                    },
                  ),
                  const SizedBox(height: 20),
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
