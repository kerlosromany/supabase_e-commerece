import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../core/consts/app_calculates.dart';
import '../../core/helpers/cart_bags_db.dart';
import '../models/zeina_model.dart';

class ProductZeinaWidget extends StatefulWidget {
  final String tableName;
  final ZeinaModel zeinaModel;

  const ProductZeinaWidget({
    super.key,
    required this.zeinaModel,
    required this.tableName,
  });

  @override
  State<ProductZeinaWidget> createState() => _ProductZeinaWidgetState();
}

class _ProductZeinaWidgetState extends State<ProductZeinaWidget> {
  bool _isInCart = false; // To track if product is in cart
  int _quantity = 1; // To track the current _quantity of the product

  @override
  void initState() {
    super.initState();
    _checkIfInCart(); // Check if product is already in the cart
  }

  //Function to check if the product is in the cart
  Future<void> _checkIfInCart() async {
    final product =
        await CartDatabase.instance.getProduct(widget.zeinaModel.id);
    setState(() {
      if (product != null) {
        _isInCart = true;
        _quantity = product['quantity']; // Set the _quantity from the cart
      }
    });
  }

  // Add product to cart with the complete product information
  Future<void> _addToCart() async {
    await CartDatabase.instance.addToCart(
      widget.tableName,
      widget.zeinaModel.id,
      widget.zeinaModel.productName,
      widget.zeinaModel.productPrice,
      widget.zeinaModel.productImageUrl,
      _quantity,
    );
    setState(() {
      _isInCart = true;
    });
  }

  // Remove product from cart
  Future<void> _removeFromCart() async {
    await CartDatabase.instance.removeFromCart(widget.zeinaModel.id);
    setState(() {
      _isInCart = false;
      _quantity = 1; // Reset _quantity when removed from cart
    });
  }

  // // Increment _quantity
  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
    _addToCart(); // Update cart with new _quantity
  }

  // // Decrement _quantity
  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
      _addToCart(); // Update cart with new _quantity
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 10.0),
      height: SizeHelper.h200,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1),
        borderRadius: const BorderRadius.horizontal(right: Radius.circular(10)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              height: SizeHelper.h200 - 1,
              decoration: const BoxDecoration(
                borderRadius:
                    BorderRadius.horizontal(left: Radius.circular(10)),
              ),
              child: CachedNetworkImage(
                imageUrl: widget.zeinaModel.productImageUrl,
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
                  widget.zeinaModel.productName,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AutoSizeText(
                      "${widget.zeinaModel.productPrice} \t\t",
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const AutoSizeText(
                      ": السعر",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                widget.zeinaModel.productAvailable
                    ? Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed:
                                  _isInCart ? _removeFromCart : _addToCart,
                              child: _isInCart
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
                          if (_isInCart)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: _decrementQuantity,
                                  icon: const Icon(Icons.remove),
                                ),
                                Text('$_quantity'),
                                IconButton(
                                  onPressed: _incrementQuantity,
                                  icon: const Icon(Icons.add),
                                ),
                              ],
                            ),
                        ],
                      )
                    : const AutoSizeText(
                        "المنتج غير متوفر حاليا",
                        maxLines: 1,
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
