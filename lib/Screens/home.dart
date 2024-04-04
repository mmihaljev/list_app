import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shopping_list_app/Database/sql_helper.dart';
import 'storeItems.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // All journals
  List<Map<String, dynamic>> _stores = [];

  bool _isLoading = true;
  // This function is used to fetch all data from the database
  void _refreshStores() async {
    final data = await SQLHelper.getStores();
    setState(() {
      _stores = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshStores(); // Loading the stores when the app starts
  }

  final TextEditingController _titleController = TextEditingController();

  void _showForm(int? id) async {
    if (id != null) {
      final existingStore =
          _stores.firstWhere((element) => element['id'] == id);
      _titleController.text = existingStore['name'];
    }

    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.indigo[600],
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        isScrollControlled: true,
        builder: (_) => Container(
              padding: EdgeInsets.only(
                top: 20,
                left: 36,
                right: 36,
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
                        label: Text('Name of the list'),
                        labelStyle: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Roboto'
                        ),
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
                        )
                    ),
                  ),
                  const SizedBox(
                    height: 28,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      textStyle: MaterialStateProperty.all(
                        const TextStyle(fontSize: 16, fontFamily: 'Roboto'),
                      ),
                      backgroundColor: MaterialStateProperty.all(
                        Colors.pink[300]
                      ),
                      elevation: MaterialStateProperty.all(15),
                      padding: MaterialStateProperty.all(const EdgeInsets.all(12)),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)
                        )
                      )
                    ),
                    onPressed: () async {
                      // Save new journal
                      if (id == null) {
                        await _addItem();
                      }

                      // Clear the text fields
                      _titleController.text = '';

                      // Close the bottom sheet
                      Navigator.of(context).pop();
                    },
                    child: Text(
                        'Create list',
                        style: TextStyle(fontFamily: 'Roboto', fontSize: 16),
                    ),
                  )
                ],
              ),
            ));
  }

// Insert a new journal to the database
  Future<void> _addItem() async {
    await SQLHelper.createStore(_titleController.text);
    _refreshStores();
  }

  // Delete an item
  void _deleteItem(int id) async {
    await SQLHelper.deleteStore(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('List deleted!'),
    ));
    _refreshStores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[300],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: AppBar(
            actions: [SpinKitPumpingHeart(
              color: Colors.white,
              size: 36,
            ),],
            elevation: 0,
            backgroundColor: Colors.pink[300],
            titleTextStyle: TextStyle(fontFamily: 'LeBelle',fontSize: 32),
            centerTitle: true,
            title: TweenAnimationBuilder(
                duration: Duration(seconds: 2),
                tween: Tween<double>(begin: 0, end: 1),
                builder: (BuildContext context, double _val, Widget? child) {
                  return Opacity(opacity: _val, child: child);
                },
                child: Text('My lists')
            ),
          ),
        ),
      ),
      body: _isLoading || _stores.length==0
          ? const Center(
              child: SpinKitDoubleBounce(
                color: Colors.indigo,
                size: 128,
              ),
            )
          : ListView.builder(
                itemCount: _stores.length,
                itemBuilder: (context, index) => Card(
                  color: Colors.pink[300],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  margin: const EdgeInsets.all(12),
                  child: ListTile(
                      textColor: Colors.white,
                      leading: Icon(
                          Icons.list_alt_rounded,
                          color: Colors.white
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)
                      ),
                      tileColor: Colors.indigo[600],
                      onTap: () => {
                            print(_stores.length),
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ItemsPage(
                                          storeId: _stores[index]['id'],
                                          storeName: _stores[index]['name'],
                                        )))
                          },
                      title: Text(_stores[index]['name'], style: TextStyle(fontFamily: 'Roboto', fontSize: 20)),
                      trailing: SizedBox(
                        width: 48,
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                              ),
                              onPressed: () =>
                                  _deleteItem(_stores[index]['id']),
                            ),
                      ])),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        elevation: 16,
        backgroundColor: Colors.indigo[600],
        child: const Icon(Icons.add),
        onPressed: () => _showForm(null),
      ),
    );
  }
}
