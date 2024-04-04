import 'dart:ffi';

import 'package:shopping_list_app/Database/Models/store.dart';

class Item {
  Int? itemId;
  String? name;
  String? quantity;
  Int? finished;
  Store? parentStore;
}