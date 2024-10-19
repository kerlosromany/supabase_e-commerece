import 'package:flutter/material.dart';
import '../../models/user_data_model.dart';

import '../../../main.dart';

class OrderDetailsScreen extends StatefulWidget {
  final int orderId;
  final UserDataModel userDataModel;

  const OrderDetailsScreen(
      {super.key, required this.orderId, required this.userDataModel});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  List<dynamic> orderItems = [];
  bool isLoading = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchOrderItems();
  }

  Future<void> fetchOrderItems() async {
    setState(() {
      isLoading = true;
    });

    // Fetch order items related to a specific order using the relationship
    final response = await supabase
        .from('orders')
        .select(
            'id, total_price, order_Items(id, product_name, product_price, quantity, product_image_url)')
        .eq('id', widget.orderId);

    if (response.isEmpty) {
      setState(() {
        errorMessage = 'Error fetching data: $response';
        isLoading = false;
      });
    } else {
      setState(() {
        orderItems = response[0]['order_Items'] as List<dynamic>;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order #${widget.orderId} Details'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : orderItems.isEmpty
                  ? const Center(child: Text('No items found for this order.'))
                  : Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Text(widget.userDataModel.userName ?? ""),
                              Text(widget.userDataModel.userAddress ?? ""),
                              Text(widget.userDataModel.userPhoneNumber ?? ""),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: orderItems.length,
                            itemBuilder: (context, index) {
                              final item = orderItems[index];
                              return ListTile(
                                leading: Image.network(
                                  item['product_image_url'],
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                                title: Text(item['product_name']),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Price: ${item['product_price']}'),
                                    Text('Quantity: ${item['quantity']}'),
                                  ],
                                ),
                                trailing: Text(
                                  'Total: ${(item['product_price'] * item['quantity']).toString()}',
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
    );
  }
}
