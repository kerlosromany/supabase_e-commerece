import 'package:flutter/material.dart';
import '../../../models/order_model.dart';
import '../../../models/user_data_model.dart';
import '../order_details_screen.dart';

class OrderWidget extends StatelessWidget {
  final OrderModel orderModel;
  final UserDataModel userDataModel;
  const OrderWidget({super.key, required this.orderModel, required this.userDataModel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => OrderDetailsScreen(orderId: orderModel.orderId!, userDataModel: userDataModel,)));
      },
      child: Container(
        padding: const EdgeInsets.all(6.0),
        margin: const EdgeInsets.all(6.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(userDataModel.userName ?? "Unknown"),
                const Text("اسم العميل"),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${orderModel.totalPrice}"),
                const Text("التكلفة"),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${orderModel.orderId}"),
                const Text("Order ID"),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${orderModel.area}"),
                const Text("المنطقة"),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${orderModel.userId}"),
                const Text("user ID"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
