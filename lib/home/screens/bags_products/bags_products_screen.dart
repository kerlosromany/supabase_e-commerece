import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/consts/app_calculates.dart';
import '../../models/bag_model.dart';
import '../../widgets/product_bag_widget.dart';
import '../../../main.dart';

class BagsProductsScreen extends StatefulWidget {
  final String bagsType;
  const BagsProductsScreen({super.key, required this.bagsType});

  @override
  State<BagsProductsScreen> createState() => _BagsProductsScreenState();
}

class _BagsProductsScreenState extends State<BagsProductsScreen> {
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
      final response =
          await supabase.from('bags').select().eq('productCat', widget.bagsType);

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
          backgroundColor: Colors.transparent,
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

                        return ProductBagWidget(
                          tableName: "bags",
                          bagModel: product,
                        );
                      },
                      separatorBuilder: (context, index) =>
                           SizedBox(height: SizeHelper.h10),
                    ),
        ),
      ),
    );
  }
}
