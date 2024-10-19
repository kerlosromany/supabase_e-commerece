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

class UploadBagScreen extends StatefulWidget {
  const UploadBagScreen({super.key});

  @override
  State<UploadBagScreen> createState() => _UploadBagScreenState();
}

class _UploadBagScreenState extends State<UploadBagScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _widthController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  String _selectedCategory = 'masry';
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;


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
        await supabase.storage.from('products').uploadBinary(
              filePath,
              bytes,
              fileOptions: FileOptions(contentType: _imageFile!.mimeType),
            );

    if (storageResponse.isEmpty) {
      AppFunctions.errorShowToast(msg: 'Image upload failed');
      return null;
    }

    final imageUrl = supabase.storage.from('products').getPublicUrl(filePath);
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

      // Insert product data into 'bags' table
      await supabase.from('bags').insert({
        'productName': _nameController.text,
        'productPrice': int.parse(_priceController.text),
        'productWidth': int.parse(_widthController.text),
        'productHeight': int.parse(_heightController.text),
        'productCat': _selectedCategory,
        'productImageUrl': imageUrl,
        'productAvailable': true,
      });

      AppFunctions.successShowToast(msg: "Product uploaded successfully");

      // Clear the form
      _nameController.clear();
      _priceController.clear();
      _widthController.clear();
      _heightController.clear();
      setState(() {
        _imageFile = null;
        _selectedCategory = 'masry';
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
        appBar: AppBar(title: const Text("Upload Bag")),
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
                    const SizedBox(height: 16),
                    DropdownButton<String>(
                      value: _selectedCategory,
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                      items: ['masry', 'locs', 'box']
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
