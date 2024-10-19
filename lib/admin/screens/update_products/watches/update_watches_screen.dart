import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../widgets/update_products/update_watch_widget.dart';
import '../../../../home/models/watch_model.dart';
import '../../../../home/screens/cart_screen.dart';

import '../../../../main.dart';


class UpdateWatchesScreen extends StatefulWidget {
  const UpdateWatchesScreen({super.key});

  @override
  State<UpdateWatchesScreen> createState() => _UpdateWatchesScreenState();
}

class _UpdateWatchesScreenState extends State<UpdateWatchesScreen> {
  List<Map<String, dynamic>> products = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  // Function to fetch products from Supabase
  Future<void> fetchProducts() async {
    try {
      final response = await supabase.from('watches').select();

      if (response.isNotEmpty) {
        setState(() {
          products = response;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          hasError = true;
        });
      }
    } on PostgrestException catch (e) {
      log(e.toString());
      setState(() {
        isLoading = false;
        hasError = true;
      });
    } catch (e) {
      log(e.toString());
      setState(() {
        isLoading = false;
        hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("علب ساعات"),
          centerTitle: true,
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const CartScreen()));
              },
              child: const Text("View Cart"),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : hasError
                  ? const Center(child: Text('خطأ في تحميل المنتجات'))
                  : ListView.separated(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        WatchModel product =
                            WatchModel.fromJson(products[index]);

                        return UpdateWatchWidget(
                          tableName: "watches",
                          watchModel: product,
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                    ),
        ),
      ),
    );
  }
}
