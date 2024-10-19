import 'package:flutter/material.dart';
import '../../../core/consts/app_calculates.dart';
import '../../../core/widgets/info_widget.dart';
import 'boxes_products_screen.dart';
import '../../widgets/main_widget.dart';


class BoxesScreen extends StatelessWidget {
  const BoxesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xff232531),
        appBar: AppBar( backgroundColor: Colors.transparent,),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  "بوكسات مصري",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 7),
                MainWidget(
                  imgPathP: "assets/default.jpeg",
                  titleP: "بوكس تجميع 3 قطع",
                  subTitleP: "السعر",
                  fun: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const BoxesProductsScreen(boxType: "box3_tagme3")));
                  },
                  maxLen: 3,
                ),
                 SizedBox(height: SizeHelper.h10),
                MainWidget(
                  imgPathP: "assets/default.jpeg",
                  titleP: "بوكس 11 قطعة",
                  subTitleP: "السعر",
                  fun: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const BoxesProductsScreen(boxType: "box11_AZ")));
                  },
                  maxLen: 3,
                ),
                 SizedBox(height: SizeHelper.h10),
                MainWidget(
                  imgPathP: "assets/default.jpeg",
                  titleP: "بوكس 7 قطع مستطيل سامح",
                  subTitleP: "السعر",
                  fun: () {Navigator.push(context, MaterialPageRoute(builder: (_) => const BoxesProductsScreen(boxType: "box7_mostatel_S")));},
                  maxLen: 3,
                ),
                 SizedBox(height: SizeHelper.h10),
                MainWidget(
                  imgPathP: "assets/default.jpeg",
                  titleP: "بوكس 3 قطع مدور",
                  subTitleP: "السعر",
                  fun: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const BoxesProductsScreen(boxType: "box3_Mdawer_Just")));
                  },
                  maxLen: 3,
                ),
                 SizedBox(height: SizeHelper.h10),
                const Text(
                  "بوكسات لوكس",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 7),
                MainWidget(
                  imgPathP: "assets/default.jpeg",
                  titleP: "بوكس 10 قطع",
                  subTitleP: "السعر",
                  fun: () {},
                  maxLen: 3,
                ),
                 SizedBox(height: SizeHelper.h10),
                MainWidget(
                  imgPathP: "assets/default.jpeg",
                  titleP: "بوكس 5 قطع مستطيل",
                  subTitleP: "السعر",
                  fun: () {},
                  maxLen: 3,
                ),
                 SizedBox(height: SizeHelper.h10),
                MainWidget(
                  imgPathP: "assets/default.jpeg",
                  titleP: "بوكس 5 قطع سداسي",
                  subTitleP: "السعر",
                  fun: () {},
                  maxLen: 3,
                ),
                 SizedBox(height: SizeHelper.h10),
                MainWidget(
                  imgPathP: "assets/default.jpeg",
                  titleP: "بوكس 5 قطع ثمانى",
                  subTitleP: "السعر",
                  fun: () {},
                  maxLen: 3,
                ),
                 SizedBox(height: SizeHelper.h10),
                MainWidget(
                  imgPathP: "assets/default.jpeg",
                  titleP: "بوكس 5 قطع ثمانى كبير",
                  subTitleP: "السعر",
                  fun: () {},
                  maxLen: 3,
                ),
                
                 SizedBox(height: SizeHelper.h10),
                MainWidget(
                  imgPathP: "assets/default.jpeg",
                  titleP: "بوكس 10 قطع مدور",
                  subTitleP: "السعر",
                  fun: () {},
                  maxLen: 3,
                ),
                 SizedBox(height: SizeHelper.h10),
                MainWidget(
                  imgPathP: "assets/default.jpeg",
                  titleP: "بوكس 5 قطع سداسي",
                  subTitleP: "السعر",
                  fun: () {},
                  maxLen: 3,
                ),
                 SizedBox(height: SizeHelper.h10),
                MainWidget(
                  imgPathP: "assets/default.jpeg",
                  titleP: "بوكس 11 قطعة مربع",
                  subTitleP: "السعر",
                  fun: () {},
                  maxLen: 3,
                ),
                 SizedBox(height: SizeHelper.h10),
                MainWidget(
                  imgPathP: "assets/default.jpeg",
                  titleP: "بوكس 5 قطع صغير",
                  subTitleP: "السعر",
                  fun: () {},
                  maxLen: 3,
                ),
                 SizedBox(height: SizeHelper.h20),
                const InfoWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
