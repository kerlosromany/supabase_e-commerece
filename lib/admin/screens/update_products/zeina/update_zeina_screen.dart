import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../widgets/update_products/update_zeina_widget.dart';
import '../../../../home/models/zeina_model.dart';
import '../../../../home/screens/cart_screen.dart';

import '../../../../main.dart';

class UpdateZeinaScreen extends StatefulWidget {
  const UpdateZeinaScreen({super.key});

  @override
  State<UpdateZeinaScreen> createState() => _UpdateZeinaScreenState();
}

class _UpdateZeinaScreenState extends State<UpdateZeinaScreen> {
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
      final response = await supabase.from('zeina').select();

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
                        ZeinaModel product =
                            ZeinaModel.fromJson(products[index]);

                        return UpdateZeinaWidget(
                          tableName: "zeina",
                          zeinaModel: product,
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
