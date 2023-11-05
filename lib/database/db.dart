import 'package:sqflite/sqflite.dart';

late Database _database;

Future<Database> get database async {
  _database = await _initDb();
  return _database;
}

Future<Database> _initDb() async {
  var path = await getDatabasesPath();
  var db = openDatabase(
    '$path/story.db',
    onCreate: (db, version) async {
      await db.execute('''CREATE TABLE userToken (
        userId STRING PRIMARY KEY,
        name TEXT,
        token TEXT
      )''');
    },
    version: 1,
  );
  return db;
}
