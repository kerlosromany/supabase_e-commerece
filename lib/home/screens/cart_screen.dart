import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../admin/widgets/loading_container.dart';
import '../../core/consts/app_calculates.dart';
import '../../core/helpers/cart_bags_db.dart';
import '../../core/helpers/functions.dart';

import '../../main.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, dynamic>> cartItems = [];
  double totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    final items = await CartDatabase.instance.getAllCartItems();
    setState(() {
      cartItems = items;
      calculateTotalPrice();
    });
  }

  void calculateTotalPrice() {
    totalPrice = 0.0;
    for (var item in cartItems) {
      totalPrice += item['productPrice'] * item['quantity'];
    }
  }

  Future<void> incrementQuantity(int prodId, int currentQuantity) async {
    await CartDatabase.instance.updateQuantity(prodId, currentQuantity + 1);
    fetchCartItems();
  }

  Future<void> decrementQuantity(int prodId, int currentQuantity) async {
    if (currentQuantity > 1) {
      await CartDatabase.instance.updateQuantity(prodId, currentQuantity - 1);
      fetchCartItems();
    }
  }

  Future<void> removeFromCart(int prodId) async {
    await CartDatabase.instance.removeFromCart(prodId);
    fetchCartItems();
    AppFunctions.warningShowToast(msg: "تم مسح المنتج من السلة");
  }

  ////////////////////////////////////////
  bool _UploadingOrder = false;
  void sendOrder() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      AppFunctions.warningShowToast(msg: "User not logged in");
      return;
    }
    setState(() {
      _UploadingOrder = true;
    });

    try {
      final userData = await supabase
          .from('users')
          .select('area')
          .eq('userId', userId)
          .limit(1)
          .single();
      log(userData.toString());
      // Insert the order into the 'orders' table
      // log("1: Inserting order");
      final orderResponse = await supabase.from('orders').insert({
        'user_id': userId,
        'total_price': totalPrice,
        'created_at': DateTime.now().toIso8601String(),
        "area": userData["area"] ?? "",
      }).select('id');

      // log("2: Order response: $orderResponse");

      final orderId = orderResponse.first['id']; // Get the order ID
      // log("Order ID: $orderId");

      if (orderId != null) {
        // Check cart items
        // log("Cart items: $cartItems");
        if (cartItems.isEmpty) {
          AppFunctions.errorShowToast(
              msg: "لا توجد منتجات تم اختيارها حتي الان");
          return;
        }

        // Prepare order items for insertion
        final orderItems = cartItems.map((item) {
          return {
            'order_id': orderId,
            'prod_id': item['prodId'],
            'product_name': item['productName'],
            'product_price': item['productPrice'],
            'quantity': item['quantity'],
            'product_image_url': item['productImageUrl'],
          };
        }).toList();

        // log("3: Inserting order items: $orderItems");

        // Insert each cart item into the 'order_items' table
        final insertResponse =
            await supabase.from('order_Items').insert(orderItems).select();

        // log("1 => ${insertResponse.toString()}");
        // insertResponse.clear();
        // log("2 => ${insertResponse.toString()}");

        // log("4: Insert response: $insertResponse");

        if (insertResponse.isEmpty) {
          // log("Error inserting order items: $insertResponse");
          // If inserting order items fails, delete the created order
          await supabase.from('orders').delete().eq('id', orderId);
          AppFunctions.errorShowToast(
              msg:
                  "خطأ في ارسال الأوردر حاول مرة اخري و تأكد من الاتصال الجيد بالانترنت");
          return;
        }

        // Show success dialog
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Order Sent!'),
              content: const Text('Your order has been sent successfully.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }

        // Clear the cart after order is placed
        await CartDatabase.instance.clearCart();
        fetchCartItems(); // Update the UI after clearing the cart
      } else {
        log("Order ID is null, failed to insert order");
        AppFunctions.errorShowToast(
            msg:
                "خطأ في ارسال الأوردر حاول مرة اخري و تأكد من الاتصال الجيد بالانترنت");
      }
    } on PostgrestException catch (e) {
      log("PostgrestException: $e");
      AppFunctions.errorShowToast(
          msg:
              "خطأ في ارسال الأوردر حاول مرة اخري و تأكد من الاتصال الجيد بالانترنت");
    } catch (e) {
      log("General Exception: $e");
      AppFunctions.errorShowToast(
          msg:
              "خطأ في ارسال الأوردر حاول مرة اخري و تأكد من الاتصال الجيد بالانترنت");
    } finally {
      setState(() {
        _UploadingOrder = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Cart items list
              Expanded(
                child: cartItems.isEmpty
                    ? const Center(
                        child: Text("Your cart is empty"),
                      )
                    : ListView.builder(
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartItems[index];
                          return Card(
                            
                            margin: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  // Product image
                                  Expanded(
                                    flex: 3,
                                    child: CachedNetworkImage(
                                      imageUrl: item['productImageUrl'],
                                      fit: BoxFit.fill,
                                      placeholder: (context, url) => const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Center(
                                        child: Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                   SizedBox(width: SizeHelper.w10),
                                  // Product details
                                  Expanded(
                                    flex: 4,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        AutoSizeText(maxLines: 2,
                                          item['productName'],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w900,
                                              fontSize: 16),
                                        ),
                                        AutoSizeText(maxLines: 1,
                                          "${item['productPrice']} :السعر",
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.remove),
                                              onPressed: () => decrementQuantity(
                                                  item['prodId'], item['quantity']),
                                            ),
                                            Text(
                                              '${item['quantity']}',
                                              style: const TextStyle(fontSize: 18),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.add),
                                              onPressed: () => incrementQuantity(
                                                  item['prodId'], item['quantity']),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
          
                                  // Remove from cart
                                  Expanded(
                                    flex: 1,
                                    child: IconButton(
                                      icon:
                                          const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => removeFromCart(item['prodId']),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
          
              // Bottom bar with total price and send order button
              BottomAppBar(
                height: 100,
                color: Colors.transparent.withOpacity(0.5),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                  height: 85,
                  child: Row(
                    children: [
                      // Total price
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const AutoSizeText(
                              'Total:',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                              maxLines: 1,
                            ),
                            AutoSizeText(
                              totalPrice.toStringAsFixed(2),
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
          
                      // Send order button
                      Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          onPressed: _UploadingOrder? null : sendOrder,
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 30)),
                          child: const Text(
                            'ارسال الطلب',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
           _UploadingOrder? const LoadingContainer() : const SizedBox.shrink()
        ],
      ),
    );
  }
}
