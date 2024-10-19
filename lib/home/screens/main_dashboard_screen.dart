import 'package:flutter/material.dart';
import '../../auth/view/screens/profile_screen.dart';
import '../../core/consts/app_calculates.dart';
import '../../core/widgets/info_widget.dart';
import 'bags_products/bags_screen.dart';
import 'boxes_products/boxes_screen.dart';
import 'cart_screen.dart';
import 'accessories/watch_boxes_screen.dart';
import 'accessories/zeina_screen.dart';
import '../widgets/main_widget.dart';

class MainDashboardScreen extends StatelessWidget {
  const MainDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const CartScreen()));
              },
              icon: const Icon(Icons.shopping_cart_outlined),
            ),
             SizedBox(width: SizeHelper.w15),
            IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ProfileScreen()));
              },
              icon: const Icon(Icons.person),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              MainWidget(
                imgPathP: "assets/bags.jpg",
                subTitleP: "جميع انواع الشنط المستورد و الشعبي",
                titleP: "شنط هدايا",
                fun: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const BagsScreen()));
                },
              ),
               SizedBox(height: SizeHelper.h10),
              MainWidget(
                imgPathP: "assets/boxes.jpg",
                subTitleP: "جميع انواع البوكسات المستوردة و الشعبي",
                titleP: "بوكسات هدايا",
                fun: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const BoxesScreen()));
                },
              ),
               SizedBox(height: SizeHelper.h10),
              MainWidget(
                imgPathP: "assets/zeina.jpeg",
                subTitleP: "جميع انواع التزيين",
                titleP: "تزيين الشنط و البوكسات",
                fun: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const ZeinaScreen()));
                },
              ),
               SizedBox(height: SizeHelper.h10),
              MainWidget(
                imgPathP: "assets/watch_boxes.jpg",
                titleP: "علب ساعات",
                subTitleP: "جميع انواع علب الساعات",
                fun: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const WatchesProductsScreen()));
                },
              ),
              const SizedBox(height: 20),
              const InfoWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
