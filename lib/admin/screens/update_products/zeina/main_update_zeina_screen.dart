import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; 
import '../../../widgets/product_price_w_h.dart';
import '../../../../core/helpers/functions.dart';
import '../../../../home/models/zeina_model.dart';

import '../../../../main.dart';

class MainUpdateZeinaScreen extends StatefulWidget {
  final String tableName;
  final ZeinaModel zeinaModel;

  const MainUpdateZeinaScreen({
    super.key,
    required this.zeinaModel,
    required this.tableName,
  });

  @override
  State<MainUpdateZeinaScreen> createState() => _MainUpdateZeinaScreenState();
}

class _MainUpdateZeinaScreenState extends State<MainUpdateZeinaScreen> {
  late TextEditingController priceController;
  bool isAvailable = false;

  @override
  void initState() {
    super.initState();
    // Initializing the controllers and state variables
    priceController =
        TextEditingController(text: widget.zeinaModel.productPrice.toString());
    isAvailable = widget.zeinaModel.productAvailable;
  }

  bool isUpdating = false;

  Future<void> updateProduct() async {
    try {
      setState(() {
        isUpdating = true;
      });
      await supabase
          .from(widget.tableName)
          .update({
            'productPrice': int.parse(priceController.text),
            'productAvailable': isAvailable,
          })
          .eq('id', widget.zeinaModel.id);
      AppFunctions.successShowToast(msg: "تم تعديل المنتج بنجاح");
    } on PostgrestException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating product: ${e.toString()}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating product: ${e.toString()}')),
        );
      }
    } finally {
      setState(() {
        isUpdating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(
          widget.zeinaModel.productName,
          maxLines: 1,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Displaying the product image
              Center(
                child: SizedBox(
                  height: 200,
                  child: CachedNetworkImage(
                    imageUrl: widget.zeinaModel.productImageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Product name display
              Text(
                widget.zeinaModel.productName,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              // Field to update product price
              ProductPriceWH(
                controller: priceController,
                labelTxt: "السعر",
                maxLen: 3,
              ),
              const SizedBox(height: 20),
              // Switch for product availability
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Product Available:',
                    style: TextStyle(fontSize: 18),
                  ),
                  Switch(
                    value: isAvailable,
                    onChanged: (value) {
                      setState(() {
                        isAvailable = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // Button to submit the update
              Center(
                child: isUpdating
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: isUpdating ? null : updateProduct,
                        child: const Text('Update Product'),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    priceController.dispose();
    super.dispose();
  }
}
