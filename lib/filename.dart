import 'package:flutter/material.dart';
import 'package:myfirstapp/logintaskexample.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardClass extends StatefulWidget {
  const DashboardClass({super.key});

  @override
  State<DashboardClass> createState() => _DashboardClassState();
}

class _DashboardClassState extends State<DashboardClass> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _imageController = TextEditingController();
  List<Map<String, String>> _items = [];
  List<Map<String, String>> _filteredItems = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? itemList = prefs.getStringList('items');
    if (itemList != null) {
      _items = itemList.map((item) {
        final parts = item.split(',');
        return {
          'name': parts[0],
          'price': parts[1],
          'image': parts[2],
        };
      }).toList();
    }
    _filteredItems = _items;
    setState(() {});
  }

  Future<void> _saveItem() async {
    if (_nameController.text.isNotEmpty &&
        _priceController.text.isNotEmpty &&
        _imageController.text.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _items.add({
        'name': _nameController.text,
        'price': _priceController.text,
        'image': _imageController.text,
      });
      await _updateSharedPreferences();
      _nameController.clear();
      _priceController.clear();
      _imageController.clear();
      _filteredItems = _items;
      setState(() {});
    }
  }

  Future<void> _updateSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> itemList = _items
        .map((item) => '${item['name']},${item['price']},${item['image']}')
        .toList();
    await prefs.setStringList('items', itemList);
  }

  void _showEditDialog(int index) {
    if (index >= 0) {
      _nameController.text = _items[index]['name']!;
      _priceController.text = _items[index]['price']!;
      _imageController.text = _items[index]['image']!;
    } else {
      _nameController.clear();
      _priceController.clear();
      _imageController.clear();
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(index >= 0 ? 'Edit Item' : 'Add Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Enter item name'),
              ),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Enter item price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _imageController,
                decoration: InputDecoration(labelText: 'Enter image path'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (index >= 0) {
                  _items[index] = {
                    'name': _nameController.text,
                    'price': _priceController.text,
                    'image': _imageController.text,
                  };
                } else {
                  _saveItem();
                }
                _updateSharedPreferences();
                Navigator.of(context).pop();
                setState(() {});
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _deleteItem(int index) {
    setState(() {
      _items.removeAt(index);
      _filteredItems = _items;
    });
    _updateSharedPreferences();
  }

  void _filterItems(String query) {
    setState(() {
      _searchQuery = query;
      _filteredItems = _items.where((item) {
        return item['name']!.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard Example'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              showLogoutDialog(context);

            },
          ),
        ],


        bottom: PreferredSize(
          preferredSize: Size.fromHeight(56.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                border: OutlineInputBorder(),
              ),
              onChanged: _filterItems,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two items per row
            childAspectRatio: 0.8, // Adjust aspect ratio for card size
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: _filteredItems.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(
                      _filteredItems[index]['image']!,

                      fit: BoxFit.cover,

                      // Cover the entire container
                             ),


                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _filteredItems[index]['name']!,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('\$${_filteredItems[index]['price']}'),
                  ),
                  ButtonBar(
                    alignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => _showEditDialog(
                            _items.indexOf(_filteredItems[index])),
                        child: Text('Edit'),
                      ),
                      TextButton(
                        onPressed: () =>
                            _deleteItem(_items.indexOf(_filteredItems[index])),
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showEditDialog(-1);
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
