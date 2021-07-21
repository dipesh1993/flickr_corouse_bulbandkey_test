import 'package:flickr_corouse_bulbandkey_test/models/reviewModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class DatabaseHelper {
  //Create a private constructor
  DatabaseHelper._();

  static const databaseName = 'review_database.db';
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database _database;

  Future<Database> get database async {
    if (_database == null) {
      return await initializeDatabase();
    }
    return _database;
  }

  initializeDatabase() async {
    return await openDatabase(join(await getDatabasesPath(), databaseName),
        version: 2, onCreate: (Database db, int version) async {
      await db.execute(
          "CREATE TABLE reviewModel(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,title TEXT,rating TEXT,ratingBy TEXT,reasonOfRating TEXT)");
    });
  }

  insertInspection(ReviewModel reviewModel) async {
    final db = await database;
    var res = await db.insert(ReviewModel.TABLENAME, reviewModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return res;
  }

  Future<List<ReviewModel>> retrieveInspection() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(ReviewModel.TABLENAME);

    return List.generate(maps.length, (i) {
      return ReviewModel(
        id: maps[i]['id'],
        title: maps[i]['title'],
        rating: maps[i]['rating'],
        ratingBy: maps[i]['ratingBy'],
        reasonOfRating: maps[i]['reasonOfRating']
      );
    });
  }

  updateInspection(ReviewModel addReviewModel) async {
    final db = await database;

    await db.update(ReviewModel.TABLENAME, addReviewModel.toMap(),
        where: 'id = ?',
        whereArgs: [addReviewModel.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  deleteInspection(int id) async {
    var db = await database;
    db.delete(ReviewModel.TABLENAME, where: 'id = ?', whereArgs: [id]);

  }
}
