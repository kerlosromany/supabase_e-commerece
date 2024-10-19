import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class CartDatabase {
  static final CartDatabase instance = CartDatabase._init();
  static Database? _database;

  CartDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('cart.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const intType = 'INTEGER NOT NULL';

    await db.execute('''
      CREATE TABLE cart (
        id $idType,
        tableName $textType,
        prodId $intType,
        productName $textType,
        productPrice $intType,
        productImageUrl $textType,
        quantity $intType
      )
    ''');
  }

  Future<int> addToCart(
    String tableName,
    int prodId,
    String productName,
    int productPrice,
    String productImageUrl,
    int quantity,
  ) async {
    final db = await instance.database;

    // Check if the product already exists
    final existingProduct = await getProduct(prodId);
    if (existingProduct != null) {
      // Update quantity if product exists
      return await updateQuantity(prodId, existingProduct['quantity'] + 1);
    }

    final data = {
      'tableName': tableName,
      'prodId': prodId,
      'productName': productName,
      'productPrice': productPrice,
      'productImageUrl': productImageUrl,
      'quantity': quantity,
    };
    return await db.insert('cart', data);
  }

  Future<int> updateQuantity(int prodId, int quantity) async {
    final db = await instance.database;
    return await db.update(
      'cart',
      {'quantity': quantity},
      where: 'prodId = ?',
      whereArgs: [prodId],
    );
  }

  Future<int> removeFromCart(int prodId) async {
    final db = await instance.database;
    return await db.delete('cart', where: 'prodId = ?', whereArgs: [prodId]);
  }

  Future<Map<String, dynamic>?> getProduct(int prodId) async {
    final db = await instance.database;
    final result = await db.query('cart', where: 'prodId = ?', whereArgs: [prodId]);

    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getAllCartItems() async {
    final db = await instance.database;
    return await db.query('cart');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  Future<void> clearCart() async {
  final db = await instance.database;
  await db.delete('cart'); // Delete all items from the cart table
}

}
