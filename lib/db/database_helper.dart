import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/item.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('lista_compras.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        quantidade INTEGER NOT NULL,
        comprado INTEGER NOT NULL
      )
    ''');
  }

  Future<void> insertItem(Item item) async {
    final db = await instance.database;
    await db.insert('items', item.toMap());
  }

  Future<List<Item>> fetchItems() async {
    final db = await instance.database;
    final result = await db.query('items');
    return result.map((json) => Item.fromMap(json)).toList();
  }
}
