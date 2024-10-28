import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:myfirstapp/editproductfile.dart';
import 'package:myfirstapp/logintaskexample.dart';
import 'package:myfirstapp/productexample.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> products = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? productList = prefs.getStringList('products');

    if (productList != null) {
      products = productList
          .map((product) => Map<String, dynamic>.from(jsonDecode(product)))
          .toList();
    }
    setState(() {});
  }

  void _deleteProduct(int index) async {
    products.removeAt(index);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> updatedList = products
        .map((product) => jsonEncode(product))
        .toList();
    await prefs.setStringList('products', updatedList);
    setState(() {});
    Fluttertoast.showToast(msg: 'Product deleted');
  }

  void _editProduct(Map<String, dynamic> product) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditProductPage(product: product, onProductUpdated: _loadProducts),
      ),
    );
  }

  void _searchProduct(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredProducts = products
        .where((product) => product['name']
        .toLowerCase()
        .contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(title: Center(child: Text('Product List',style: TextStyle(color: Colors.black),)),


          actions: [
          IconButton(
          icon: Icon(Icons.logout),
      onPressed: () {
        showLogoutDialog(context);

      },
    ),
    ],
      ),





      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Search Products',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0), // Border radius set karna
                  borderSide: BorderSide(color: Colors.blue),
                  // Border color
                ),
              prefixIcon: Icon(Icons.search),),
              onChanged: _searchProduct,
            ),
            SizedBox(height: 16),
            Expanded(
              child: filteredProducts.isEmpty
                  ? Center(child: Text('No Product Found'))
                  : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (filteredProducts[index]['image'] != null)
                          Image.file(
                            File(filteredProducts[index]['image']),
                            height: 100,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            filteredProducts[index]['name'],
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Price: \$${filteredProducts[index]['price']}',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              color: Colors.blue,
                              onPressed: () => _editProduct(filteredProducts[index]),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              color: Colors.red,
                              onPressed: () => _deleteProduct(products.indexOf(filteredProducts[index])),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddProductPage(onProductAdded: _loadProducts),
            ),
          );
        },
        child: Icon(Icons.add),
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
                                                            color: Colors.black
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
                                                                  .circular(5),
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
                                                                      style:
                                                                      TextStyle(
                                                                        decoration:
                                                                        TextDecoration
                                                                            .none,
                                                                        fontSize:
                                                                        14.0,
                                                                        color: Colors.orange,
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
                                                        SharedPreferences pref =
                                                        await SharedPreferences
                                                            .getInstance();
                                                        setState(() {
                                                          pref.clear();
                                                          Navigator.pushAndRemoveUntil(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      LoginExample()),
                                                              ModalRoute.withName(
                                                                  "/LoginExample"));
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
                                                            color: Colors.black
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
                                                                  .circular(5),
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
                                                                      style:
                                                                      TextStyle(
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
