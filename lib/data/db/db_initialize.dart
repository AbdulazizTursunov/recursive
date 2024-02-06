
import 'package:path/path.dart';
import 'package:recursive/data/model/contact_model.dart';
import 'package:recursive/data/model/jadval_model.dart';
import 'package:sqlite_wrapper/sqlite_wrapper.dart';

SQLiteWrapper db = SQLiteWrapper();

class DbInitialize {
  DbInitialize._init();
  static final DbInitialize _singelton = DbInitialize._init();

  factory DbInitialize() {
    return _singelton;
  }
  static int version = 1;

  Future<DatabaseInfo> initDb(dbPath, {inMemory = true}) async {
    dbPath = join(dbPath, "base.sqlite");
    return db.openDB(
      dbPath,
      version: version,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate() async {
    List sql = [];
    sql.add(JadvalService.createTable);
    sql.add(ContactService.createContactTable);
    for (var query in sql) {
      db.execute(query);
    }
  }
}
