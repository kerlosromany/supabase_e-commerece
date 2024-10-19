import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../widgets/update_products/update_bag_widget.dart';
import '../../../../home/models/bag_model.dart';
import '../../../../home/screens/cart_screen.dart';

import '../../../../main.dart';

class UpdateBagsScreen extends StatefulWidget {
  final String bagsType;
  const UpdateBagsScreen({super.key, required this.bagsType});

  @override
  State<UpdateBagsScreen> createState() => _UpdateBagsScreenState();
}

class _UpdateBagsScreenState extends State<UpdateBagsScreen> {
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
          .from('bags')
          .select()
          .eq('productCat', widget.bagsType);

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
          title: const Text('شنط الهدايا الشعبي'),
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
                        BagModel product = BagModel.fromJson(products[index]);

                        return UpdateBagWidget(
                          tableName: "bags",
                          bagModel: product,
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10)),
        ),
      ),
    );
  }
}
