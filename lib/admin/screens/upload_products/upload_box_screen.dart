import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../widgets/loading_container.dart';
import '../../widgets/product_name_field.dart';
import '../../widgets/product_price_w_h.dart';
import '../../../core/helpers/functions.dart';
import '../../../main.dart';

class UploadBoxScreen extends StatefulWidget {
  const UploadBoxScreen({super.key});

  @override
  State<UploadBoxScreen> createState() => _UploadBoxScreenState();
}

class _UploadBoxScreenState extends State<UploadBoxScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _highController = TextEditingController();
  final TextEditingController _piecesController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _nameController.dispose();
    _priceController.dispose();
    _widthController.dispose();
    _heightController.dispose();
    _highController.dispose();
    _piecesController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;


  final List<String> boxatTypes = [
    // بوكسات تجميع
    'box3_tagme3',
    'box4_tagme3',
    // بوكسات احمد عزمي
    'box11_AZ',
    'box10_AZ',
    'box5_Mostatel_AZ',
    'box5_Sodasy_AZ',
    'box5_Somany_Big_AZ',
    'box5_Somany_Small_AZ',
    'box5_Small_Mostatel_AZ',
    'box5_Small_Morb3_AZ',
    'box5_Sodasy_Sha3by_AZ',
    // بوكسات محمد فارس
    'box10_Mdawer_Just',
    'box3_Mdawer_Just',
    'box5_Sodasy_Just',
    'box5_Bydawy_Just',
    'box_Dorg_Just',
    'box11_MF',
    // بوكسات سامح
    'box7_mostatel_S',
    'box10_S',
    'box5_Jambo_S',
    'box11_Jambo_S',
  ];
  String _selectedCategory = 'box3_tagme3';

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        _imageFile = pickedFile;
      });
    } catch (e) {
      AppFunctions.errorShowToast(msg: "Image picker error: $e");
    }
  }

  /// Function to upload the image to Supabase Storage
  Future<String?> _uploadImage() async {
    final bytes = await _imageFile!.readAsBytes();
    final fileExt = _imageFile!.path.split('.').last;
    final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
    final filePath = fileName;

    final storageResponse =
        await supabase.storage.from('boxat_bucket').uploadBinary(
              filePath,
              bytes,
              fileOptions: FileOptions(contentType: _imageFile!.mimeType),
            );

    if (storageResponse.isEmpty) {
      AppFunctions.errorShowToast(msg: 'Image upload failed');
      return null;
    }

    final imageUrl =
        supabase.storage.from('boxat_bucket').getPublicUrl(filePath);
    return imageUrl;
  }

  Future<void> uploadProduct() async {
    if (!_formKey.currentState!.validate()) return;

    if (_imageFile == null) {
      AppFunctions.errorShowToast(
          msg: "Please fill in all fields and select an image");
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });

      // Upload image and get image URL
      final imageUrl = await _uploadImage();
      if (imageUrl == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Insert product data into 'boxat' table
      await supabase.from('boxat').insert({
        'productName': _nameController.text,
        'productPrice': int.parse(_priceController.text),
        'productWidth': int.parse(_widthController.text),
        'productHeight': int.parse(_heightController.text),
        'productHigh': int.parse(_highController.text),
        'productPieces': int.parse(_piecesController.text),
        'productCat': _selectedCategory,
        'productImageUrl': [imageUrl],
        'productAvailable': true,
      });

      AppFunctions.successShowToast(msg: "Product uploaded successfully");

      // Clear the form
      _nameController.clear();
      _priceController.clear();
      _widthController.clear();
      _heightController.clear();
      _highController.clear();
      _piecesController.clear();
      setState(() {
        _imageFile = null;
        _selectedCategory = boxatTypes[0];
        _isLoading = false;
      });
    } on PostgrestException catch (e) {
      log("Error uploading product: $e");
      AppFunctions.errorShowToast(msg: "Failed to upload product");
    } catch (e) {
      log("Error uploading product: $e");
      AppFunctions.errorShowToast(msg: "Failed to upload product");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Upload Box")),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: uploadProduct,
                        child: const Text("Upload Product"),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ProductNameField(controller: _nameController),
                    const SizedBox(height: 10),
                    ProductPriceWH(
                        controller: _priceController, labelTxt: "السعر"),
                    const SizedBox(height: 10),
                    ProductPriceWH(
                        controller: _widthController, labelTxt: "العرض"),
                    const SizedBox(height: 10),
                    ProductPriceWH(
                        controller: _heightController, labelTxt: "الطول"),
                    const SizedBox(height: 10),
                    ProductPriceWH(
                        controller: _highController, labelTxt: "الارتفاع"),
                    const SizedBox(height: 10),
                    ProductPriceWH(
                        controller: _piecesController,
                        labelTxt: "عدد القطع",
                        maxLen: 2),
                    const SizedBox(height: 16),
                    DropdownButton<String>(
                      value: _selectedCategory,
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                      items: boxatTypes
                          .map((category) => DropdownMenuItem<String>(
                                value: category,
                                child: Text(category),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: const Text("Pick Image"),
                    ),
                    _imageFile != null
                        ? Image.file(
                            File(_imageFile!.path),
                            height: 200,
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
            _isLoading ? const LoadingContainer() : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
