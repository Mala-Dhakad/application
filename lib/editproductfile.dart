import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EditProductPage extends StatefulWidget {
  final Map<String, dynamic> product;
  final Function onProductUpdated;

  const EditProductPage({Key? key, required this.product, required this.onProductUpdated}) : super(key: key);

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.product['name'];
    _priceController.text = widget.product['price'].toString();
    _imagePath = widget.product['image'];
  }

  Future<void> _updateProduct() async {
    if (_nameController.text.isEmpty || _priceController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Name and Price are required');
      return;
    }

    double? price = double.tryParse(_priceController.text);
    if (price == null) {
      Fluttertoast.showToast(msg: 'Invalid price format');
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? productList = prefs.getStringList('products');

    Map<String, dynamic> updatedProduct = {
      'name': _nameController.text,
      'price': price,
      'image': _imagePath,
    };

    int index = productList!.indexOf(jsonEncode(widget.product));
    productList[index] = jsonEncode(updatedProduct);
    await prefs.setStringList('products', productList);
    Fluttertoast.showToast(msg: 'Product updated successfully');

    widget.onProductUpdated();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Product')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Product Name'),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(
                    RegExp("[a-zA-Z ]")),
              ],
            ),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Price'),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(
                    RegExp("[0-9]")),
              ],
            ),
            SizedBox(height: 16),
            if (_imagePath != null)
              Image.file(File(_imagePath!), height: 100, width: double.infinity, fit: BoxFit.cover),
            ElevatedButton(
              onPressed: _updateProduct,
              child: Text('Update Product'),
            ),
          ],
        ),
      ),
    );
  }
}
