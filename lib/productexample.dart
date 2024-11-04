import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class AddProductPage extends StatefulWidget {
  final Function onProductAdded;

  const AddProductPage({Key? key, required this.onProductAdded}) : super(key: key);

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String? _imagePath;

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imagePath = image?.path;
    });
  }

  Future<void> _addProduct() async {
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
    List<String>? productList = prefs.getStringList('products') ?? [];

    Map<String, dynamic> newProduct = {
      'name': _nameController.text,
      'price': price,
      'image': _imagePath,
    };

    if (productList.any((product) => jsonDecode(product)['name'] == newProduct['name'])) {
      Fluttertoast.showToast(msg: 'Product already exists');
      return;
    }

    productList.add(jsonEncode(newProduct));
    await prefs.setStringList('products', productList);
    Fluttertoast.showToast(msg: 'Product added successfully');

    widget.onProductAdded();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text('Add Product',
        style: TextStyle
          (color: Colors.black,
      fontWeight: FontWeight.bold,
        ),))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(
                    RegExp("[a-zA-Z ]")),
              ],
              decoration: InputDecoration(labelText: 'Product Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0), // Border radius set karna
                  borderSide: BorderSide(color: Colors.blue), // Border color
                ),),

            ),
            SizedBox(height: 20,),
            TextField(
              controller: _priceController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(
                    RegExp("[0-9]")),
              ],
              decoration: InputDecoration(labelText: 'Price',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0), // Border radius set karna
                  borderSide: BorderSide(color: Colors.blue), // Border color
                ),),

            ),
            SizedBox(height: 16),
            _imagePath == null
                ? Text('No image selected')
                : Expanded(child: Image.file(File(_imagePath!))),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick Image'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addProduct,
              child: Text('Add Product'),
            ),
          ],
        ),
      ),
    );
  }
}
