import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../screens/update_products/boxes/main_update_box_screen.dart';
import '../../../home/models/box_model.dart';

class UpdateBoxWidget extends StatefulWidget {
  final String tableName;
  final BoxModel boxModel;

  const UpdateBoxWidget({
    super.key,
    required this.boxModel,
    required this.tableName,
  });

  @override
  State<UpdateBoxWidget> createState() => _UpdateBoxWidgetState();
}

class _UpdateBoxWidgetState extends State<UpdateBoxWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => MainUpdateBoxScreen(
                      boxModel: widget.boxModel,
                      tableName: widget.tableName,
                    )));
      },
      child: Container(
        padding: const EdgeInsets.only(right: 10.0),
        height: 200,
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
                height: 199,
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
            const SizedBox(width: 10),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AutoSizeText(
                    widget.boxModel.productName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AutoSizeText(
                        "${widget.boxModel.productPrice} \t\t",
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                      const AutoSizeText(
                        ": السعر",
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AutoSizeText(
                        "${widget.boxModel.productWidth} العرض",
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                      AutoSizeText(
                        "${widget.boxModel.productHeight} الطول",
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
