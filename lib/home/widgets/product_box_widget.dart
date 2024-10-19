import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../core/consts/app_calculates.dart';
import '../../core/helpers/cart_bags_db.dart';
import '../models/box_model.dart';

class ProductBoxWidget extends StatefulWidget {
  final String tableName;
  final BoxModel boxModel;

  const ProductBoxWidget({
    super.key,
    required this.boxModel,
    required this.tableName,
  });

  @override
  State<ProductBoxWidget> createState() => _ProductBoxWidgetState();
}

class _ProductBoxWidgetState extends State<ProductBoxWidget> {
  bool isInCart = false; // To track if product is in cart
  int quantity = 1; // To track the current quantity of the product

  @override
  void initState() {
    super.initState();
    checkIfInCart(); // Check if product is already in the cart
  }

  // Function to check if the product is in the cart
  Future<void> checkIfInCart() async {
    final product = await CartDatabase.instance.getProduct(widget.boxModel.id);
    setState(() {
      if (product != null) {
        isInCart = true;
        quantity = product['quantity']; // Set the quantity from the cart
      }
    });
  }

  // Add product to cart with the complete product information
  Future<void> addToCart() async {
    await CartDatabase.instance.addToCart(
      widget.tableName,
      widget.boxModel.id,
      widget.boxModel.productName,
      widget.boxModel.productPrice,
      widget.boxModel.productImageUrl,
      quantity,
    );
    setState(() {
      isInCart = true;
    });
  }

  // Remove product from cart
  Future<void> removeFromCart() async {
    await CartDatabase.instance.removeFromCart(widget.boxModel.id);
    setState(() {
      isInCart = false;
      quantity = 1; // Reset quantity when removed from cart
    });
  }

  // Increment quantity
  void incrementQuantity() {
    setState(() {
      quantity++;
    });
    addToCart(); // Update cart with new quantity
  }

  // Decrement quantity
  void decrementQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
      addToCart(); // Update cart with new quantity
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 10.0), 
      height:  SizeHelper.h200,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              height:  SizeHelper.h200 -1,
              decoration: const BoxDecoration(
                borderRadius:
                    BorderRadius.horizontal(left: Radius.circular(10)),
              ),
              child: CachedNetworkImage(
                imageUrl: widget.boxModel.productImageUrl,
                fit: BoxFit.fill,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const Center(
                  child: Icon(Icons.error),
                ),
              ),
            ),
          ),
         SizedBox(width: SizeHelper.w10),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AutoSizeText(
                  widget.boxModel.productName,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AutoSizeText(
                      "${widget.boxModel.productPrice} \t\t",
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const AutoSizeText(
                      ": السعر",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AutoSizeText(
                      "${widget.boxModel.productWidth} العرض",
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    AutoSizeText(
                      "${widget.boxModel.productHeight} الطول",
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                widget.boxModel.productAvailable
                    ? Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: isInCart ? removeFromCart : addToCart,
                              child: isInCart
                                  ? const AutoSizeText(
                                      "المسح من العربة",
                                      style: TextStyle(color: Colors.red),
                                    )
                                  : const AutoSizeText(
                                      "اضف الي العربة",
                                      style: TextStyle(color: Colors.white),
                                    ),
                            ),
                          ),
                          if (isInCart)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: decrementQuantity,
                                  icon: const Icon(Icons.remove),
                                ),
                                Text('$quantity'),
                                IconButton(
                                  onPressed: incrementQuantity,
                                  icon: const Icon(Icons.add),
                                ),
                              ],
                            ),
                        ],
                      )
                    : const AutoSizeText(
                        "المنتج غير متوفر حاليا",maxLines: 1,
                        style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w900),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
