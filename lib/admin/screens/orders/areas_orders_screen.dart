import 'package:flutter/material.dart';

import 'area_orders_screen.dart';

class AreasOrdersScreen extends StatelessWidget {
  const AreasOrdersScreen({super.key});




  @override
  Widget build(BuildContext context) {
    const List<String> areas = ["بنها","شبرا مصر","وسط البلد","مناطق اخري",];
    return SafeArea(
      child: Scaffold(
        body: ListView.builder(
          itemCount: 4,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => AreaOrdersScreen(area: areas[index],)));
              },
              child: Container(
                padding: const EdgeInsets.all(25.0),
                margin: const EdgeInsets.all(8.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey  ,width: 1 ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(areas[index] , style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 30),),
              ),
            );
          },
        ),
      ),
    );
  }
}
