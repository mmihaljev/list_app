import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shopping_list_app/Database/sql_helper.dart';
import 'package:shopping_list_app/Screens/closingAnimatiton.dart';

class ItemsPage extends StatefulWidget {
  int? storeId;
  String? storeName;

  ItemsPage({this.storeId, this.storeName});

  @override
  _ItemsPageState createState() =>
      _ItemsPageState(storeId: storeId, storeName: storeName);
}

class _ItemsPageState extends State<ItemsPage> {
  // All journals

  _ItemsPageState({this.storeId, this.storeName});

  List<Map<String, dynamic>> _items = [];
  String? storeName;
  int? storeId;
  bool _finished = false;

  bool _isLoading = true;
  // This function is used to fetch all data from the database
  void _refreshItems() async {
    final data = await SQLHelper.getItems(storeId);
    setState(() {
      _items = data;
      _isLoading = false;
    });
  }

  bool _convertToBool(int number) {
    if (number == 1) return true;
    return false;
  }

  @override
  void initState() {
    super.initState();
    _refreshItems(); // Loading the items when the app starts
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  void _showForm() async {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.indigo[600],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
              padding: EdgeInsets.only(
                top: 20,
                left: 36,
                right: 36,
                // this will prevent the soft keyboard from covering the text fields
                bottom: MediaQuery.of(context).viewInsets.bottom + 40,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _titleController,
                    style: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
                    decoration: const InputDecoration(
                        label: Text('Item'),
                        labelStyle: TextStyle(
                            color: Colors.white, fontFamily: 'Roboto'),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        )),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _quantityController,
                    style: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
                    decoration: const InputDecoration(
                        label: Text('Value'),
                        labelStyle: TextStyle(
                            color: Colors.white, fontFamily: 'Roboto'),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        )),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        textStyle: MaterialStateProperty.all(
                          const TextStyle(fontSize: 16, fontFamily: 'Roboto'),
                        ),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.pink[300]),
                        elevation: MaterialStateProperty.all(15),
                        padding:
                            MaterialStateProperty.all(const EdgeInsets.all(12)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)))),
                    onPressed: () async {
                      // Save new item
                      await _addItem();

                      // Clear the text fields
                      _titleController.text = '';

                      // Close the bottom sheet
                      Navigator.of(context).pop();
                    },
                    child: Text('New item'),
                  )
                ],
              ),
            ));
  }

// Insert a new item to the database
  Future<void> _addItem() async {
    await SQLHelper.createItem(
        _titleController.text, _quantityController.text, storeId);
    _refreshItems();
  }

  // Update an existing item
  Future<void> _updateItem(int id) async {
    await SQLHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Doneeee!'),
    ));
    _refreshItems();
    if (_items.length == 1) {
      _finished = true;
      await SQLHelper.deleteStore(storeId);
    }
    ;
  }

  // Delete an item
  void _deleteItem(int id) async {
    await SQLHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Item deleted!'),
    ));
    _refreshItems();
  }

  @override
  Widget build(BuildContext context) {
    return _finished
        ? ClosingAnimation()
        : Scaffold(
            backgroundColor: Colors.pink[300],
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(80),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: AppBar(
                  actions: [
                    SpinKitPumpingHeart(
                      color: Colors.white,
                      size: 36,
                    ),
                  ],
                  title: Text(storeName!),
                  backgroundColor: Colors.pink[300],
                  elevation: 0,
                  centerTitle: true,
                  titleTextStyle: TextStyle(fontFamily: 'Roboto', fontSize: 28),
                ),
              ),
            ),
            body: _isLoading || _items.length == 0
                ? const Center(
                    child: SpinKitDoubleBounce(
                      color: Colors.indigo,
                      size: 128,
                    ),
                  )
                : ListView.builder(
                    itemCount: _items.length,
                    itemBuilder: (context, index) => Card(
                      color: Colors.indigo[600],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      margin: const EdgeInsets.all(12),
                      child: ListTile(
                          leading: _convertToBool(_items[index]['finished'])
                              ? Icon(Icons.filter_list_rounded,
                                  color: Colors.white, size: 40)
                              : Icon(Icons.filter_list_rounded,
                                  color: Colors.white, size: 40),
                          textColor: Colors.white,
                          title: Text(
                            _items[index]['name'],
                            style: TextStyle(fontSize: 18),
                          ),
                          subtitle: Text(_items[index]['quantity']),
                          trailing: SizedBox(
                            width: 100,
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.white, size: 28),
                                  onPressed: () =>
                                      _deleteItem(_items[index]['id']),
                                ),
                                IconButton(
                                    onPressed: () =>
                                        _updateItem(_items[index]['id']),
                                    icon: const Icon(
                                      Icons.check_circle_outline,
                                      color: Colors.green,
                                      size: 28,
                                    ))
                              ],
                            ),
                          )),
                    ),
                  ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.indigo[600],
              child: const Icon(Icons.add),
              onPressed: () {
                _titleController.clear();
                _quantityController.clear();
                _showForm();
              },
            ),
          );
  }
}
