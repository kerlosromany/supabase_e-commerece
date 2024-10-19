import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../widgets/update_products/update_box_widget.dart';
import '../../../../home/models/box_model.dart';
import '../../../../home/screens/cart_screen.dart';
import '../../../../main.dart';


class UpdateBoxesScreen extends StatefulWidget {
  final String boxType;
  const UpdateBoxesScreen({super.key, required this.boxType});

  @override
  State<UpdateBoxesScreen> createState() => _UpdateBoxesScreenState();
}

class _UpdateBoxesScreenState extends State<UpdateBoxesScreen> {
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
      final response = await supabase
          .from('boxat')
          .select()
          .eq('productCat', widget.boxType);

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
          title: const Text("بوكسات هدايا"),
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
                        BoxModel product = BoxModel.fromJson(products[index]);

                        return UpdateBoxWidget(
                          tableName: "boxat",
                          boxModel: product,
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
