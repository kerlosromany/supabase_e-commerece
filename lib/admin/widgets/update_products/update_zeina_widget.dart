import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../screens/update_products/zeina/main_update_zeina_screen.dart';
import '../../../home/models/zeina_model.dart';

class UpdateZeinaWidget extends StatefulWidget {
  final String tableName;
  final ZeinaModel zeinaModel;

  const UpdateZeinaWidget({
    super.key,
    required this.zeinaModel,
    required this.tableName,
  });

  @override
  State<UpdateZeinaWidget> createState() => _UpdateZeinaWidgetState();
}

class _UpdateZeinaWidgetState extends State<UpdateZeinaWidget> {
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
                builder: (_) => MainUpdateZeinaScreen(
                      zeinaModel: widget.zeinaModel,
                      tableName: widget.tableName,
                    )));
      },
      child: Container(
        padding: const EdgeInsets.only(right: 10.0),
        height: 200,
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
                height: 199,
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
            const SizedBox(width: 10),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AutoSizeText(
                    widget.zeinaModel.productName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AutoSizeText(
                        "${widget.zeinaModel.productPrice} \t\t",
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                      const AutoSizeText(
                        ": السعر",
                        style: TextStyle(fontWeight: FontWeight.w900),
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
