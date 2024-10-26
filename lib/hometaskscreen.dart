import 'package:flutter/material.dart';
import 'package:myfirstapp/logintaskexample.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyClassApp extends StatefulWidget {
  const MyClassApp({super.key});

  @override
  State<MyClassApp> createState() => _MyClassAppState();
}

class _MyClassAppState extends State<MyClassApp> {
  List<Map<String, dynamic>> _products = [
    {'name': 'Headphone', 'price': 1.2, 'image': 'assets/headphoneone.jpeg'},
    {'name': 'Headphone', 'price': 0.5, 'image': 'assets/headphonetwo.jpeg'},
    {'name': 'USB ceble', 'price': 2.0, 'image': 'assets/cableone.jpeg'},
    {'name': 'ceble', 'price': 3.0, 'image': 'assets/cablesecond.png'},
  ];


  List<Map<String, dynamic>> _filteredProducts = [];
  String _searchQuery = '';


  void _deleteProduct(int index) {
    setState(() {
      _products.removeAt(index);
    });
  }

  void _addProduct(String name, double price, String image) {
    setState(() {
      _products.add({'name': name, 'price': price, 'image': image});
      _updateSearchQuery(_searchQuery);
    });
  }

  void _editProduct(int index) {
    final TextEditingController nameController = TextEditingController(
        text: _products[index]['name']);
    final TextEditingController priceController = TextEditingController(
        text: _products[index]['price'].toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Product Name'),
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Product Price'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text("Save"),
              onPressed: () {
                String name = nameController.text;
                double price = double.tryParse(priceController.text) ?? 0.0;

                if (name.isNotEmpty && price > 0) {
                  setState(() {
                    _products[index] = {
                      'name': name,
                      'price': price,
                      'image': _products[index]['image']
                    }; // Update product
                  });
                  Navigator.of(context).pop(); // Close the dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$name updated')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddProductDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    final TextEditingController imageController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Product Name'),
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Product Price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: imageController,
                decoration: InputDecoration(labelText: 'Image Asset Path'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text("Add"),
              onPressed: () {
                String name = nameController.text;
                double price = double.tryParse(priceController.text) ?? 0.0;
                String image = imageController.text;

                if (name.isNotEmpty && price > 0 && image.isNotEmpty) {
                  _addProduct(name, price, image);
                  Navigator.of(context).pop(); // Close the dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$name added')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override

  void initState() {
    super.initState();
    _filteredProducts = _products; // Initialize with all products
  }
  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
      _filteredProducts = _products
          .where((product) => product['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomeScreen',style: TextStyle(fontSize: 25,
        color: Colors.black,
        fontWeight: FontWeight.bold),),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              showLogoutDialog(context);

            },
          ),
        ],
        centerTitle: true,
      ),
      body:
      ListView.builder(
        itemCount: (_products.length + 1) ~/ 2, // Count rows
        itemBuilder: (context, rowIndex) {

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              Expanded(
                child: _buildProductCard(rowIndex * 2), // First card in row
              ),
              if ((rowIndex * 2 + 1) <
                  _products.length) // Check if the second item exists
                Expanded(
                  child: _buildProductCard(
                      rowIndex * 2 + 1), // Second card in row
                ),

            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddProductDialog, // Show the dialog when pressed
        child: Icon(Icons.add),
        tooltip: 'Add Product',
      ),
    );
  }

  Widget _buildProductCard(int index) {
    final product = _products[index];


    return Card(
      margin: EdgeInsets.all(8.0),
      child: Stack(
        children: [
        Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Add an image to the card
          Center(
            child: Container(
              height: 150,
              width: 140,

              child: Image.asset(
                product['image'],
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              product['name'],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Text('\$${product['price'].toString()}'),
        ],
      ),
      Positioned(
        left: 8.0,
        top: 8.0,
        child: Row(
            children: [

        IconButton(
        icon: Icon(Icons.edit, color: Colors.blue),
        onPressed: () {
          _editProduct(index); // Show edit dialog
        },
      ),

    IconButton(
    icon: Icon(Icons.delete, color: Colors.red),
    onPressed: () {
    // Show confirmation dialog before deleting
    showDialog(
    context: context,
    builder: (BuildContext context) {
    return AlertDialog(
    title: Text("Delete ${product['name']}"),
    content: Text("Are you sure you want to delete this item?"),
    actions: [
    TextButton(
    child: Text("Cancel"),
    onPressed: () {
    Navigator.of(context).pop(); // Close the dialog
    },
    ),


    TextButton(
    child: Text("Delete"),
    onPressed: () {
    _deleteProduct(index);
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('${product['name']} deleted')),
    );
    Navigator.of(context).pop(); // Close the dialog
    },
    ),
    ],
    );
    },
    );
    },
    ),
    ],
    ),
    ),
    ],
    ),
    );

  }

  showLogoutDialog(BuildContext context) {
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: "dialog",
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return Center(
            child: Wrap(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Center(
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            // if you need this

                            side: BorderSide(
                              color: Colors.white.withOpacity(.5),
                              width: 1,
                            ),
                          ),
                          color: Colors.transparent,
                          elevation: 1,
                          margin: EdgeInsets.all(0),
                          child: Container(
                              width: MediaQuery.of(context).size.width - 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.white,
                                        Colors.white,
                                      ])),
                              child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Wrap(
                                    children: [
                                      Padding(
                                        padding:
                                        EdgeInsets.fromLTRB(20, 20, 20, 20),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                              EdgeInsets.only(bottom: 10),
                                              child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "Are You Want To Logout?",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        decoration:
                                                        TextDecoration.none,
                                                        fontSize: 16.0,
                                                        color: Colors.black,
                                                       ),
                                                  )),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                Center(
                                                    child: InkWell(
                                                      onTap: () async {

                                                        Navigator.of(context,
                                                            rootNavigator: true)
                                                            .pop('dialog');

                                                      },
                                                      child: Card(
                                                        shape:
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                          // if you need this

                                                          side: BorderSide(
                                                            color: Colors.white
                                                                .withOpacity(.5),
                                                            width: 1,
                                                          ),
                                                        ),
                                                        elevation: 1,
                                                        margin: EdgeInsets.all(2),
                                                        child: Container(
                                                            decoration:
                                                            BoxDecoration(
                                                                borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                    5),
                                                                ),
                                                            child: Padding(
                                                              padding:
                                                              EdgeInsets.all(
                                                                  10),
                                                              child: Container(
                                                                width: 50,
                                                                child: Align(
                                                                    alignment:
                                                                    Alignment
                                                                        .center,
                                                                    child: Text(
                                                                      "Cancel",
                                                                      textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                      style: TextStyle(
                                                                          decoration:
                                                                          TextDecoration
                                                                              .none,
                                                                          fontSize:
                                                                          14.0,
                                                                          color: Colors
                                                                              .white,

                                                                          ),
                                                                    )),
                                                              ),
                                                            )),
                                                      ),
                                                    )),
                                                Center(
                                                    child: InkWell(
                                                      onTap: () async {
                                                        Navigator.of(context,
                                                            rootNavigator: true)
                                                            .pop('dialog');
                                                        SharedPreferences pref = await SharedPreferences.getInstance();
                                                        setState(() {

                                                          pref.clear();
                                                          Navigator.pushAndRemoveUntil(
                                                              context,
                                                              MaterialPageRoute(builder: (context) => LoginExample()),
                                                              ModalRoute.withName("/LoginExample"));
                                                        });


                                                      },
                                                      child: Card(
                                                        shape:
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                          // if you need this

                                                          side: BorderSide(
                                                            color: Colors.white
                                                                .withOpacity(.5),
                                                            width: 1,
                                                          ),
                                                        ),
                                                        color: Colors.white,
                                                        elevation: 1,
                                                        margin: EdgeInsets.all(10),
                                                        child: Container(
                                                            decoration:
                                                            BoxDecoration(
                                                                borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                    5),
                                                                ),
                                                            child: Padding(
                                                              padding:
                                                              EdgeInsets.all(
                                                                  10),
                                                              child: Container(
                                                                width: 50,
                                                                child: Align(
                                                                    alignment:
                                                                    Alignment
                                                                        .center,
                                                                    child: Text(
                                                                      "Logout",
                                                                      textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                      style: TextStyle(
                                                                          decoration:
                                                                          TextDecoration
                                                                              .none,
                                                                          fontSize:
                                                                          14.0,


                                                                          ),
                                                                    )),
                                                              ),
                                                            )),
                                                      ),
                                                    )),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ))),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }
}


