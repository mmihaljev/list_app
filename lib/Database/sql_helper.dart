import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    Batch batch = database.batch();
    batch.execute("""CREATE TABLE stores(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT  
      )
      """);
    batch.execute("""CREATE TABLE items(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT,
        quantity TEXT,
        finished INTEGER,
        storeid INTEGER,
        FOREIGN KEY (storeid) REFERENCES stores (id)
      )
      """);
    List<dynamic> res = await batch.commit();
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'shoppinglist.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Create new store
  static Future<int> createStore(String name) async {
    final db = await SQLHelper.db();

    final data = {'name': name};
    final id = await db.insert('stores', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Create new item
  static Future<int> createItem(String name, String quantity, int? storeid) async {
    final db = await SQLHelper.db();

    final data = {'name': name, 'quantity': quantity, 'finished': 0, 'storeid': storeid};
    final id = await db.insert('items', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all stores
  static Future<List<Map<String, dynamic>>> getStores() async {
    final db = await SQLHelper.db();
    return db.query('stores', orderBy: "id");
  }

  // Read one stores
  static Future<List<Map<String, dynamic>>> getStore(int? id) async {
    final db = await SQLHelper.db();
    return db.query('stores', where: 'id = ?', whereArgs: [id], limit: 1);
  }

  // Read all items
  static Future<List<Map<String, dynamic>>> getItems(int? storeid) async {
    final db = await SQLHelper.db();
    return db.query('items', orderBy: "id", where: 'storeid = ?', whereArgs: [storeid]);
  }

  // Update an item by id
  static Future<int> updateItem(
      int id, String name, String? quantity, int finished) async {
    final db = await SQLHelper.db();

    final data = {
      'name': name,
      'quantity': quantity,
      'finished': finished
    };

    final result =
    await db.update('items', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete store
  static Future<void> deleteStore(int? id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("stores", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  // Delete item
  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("items", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}