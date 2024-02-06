import 'package:flutter/material.dart';
import 'package:recursive/data/db/crud_service.dart';
import 'package:recursive/data/db/db_initialize.dart';

class Jadval{
  Jadval();

  static CrudService service = JadvalService();
  static Map<int, Jadval> obektlar = {};

  int tr=0;
  int trBobo = 0;
  String nomi='';
  DateTime time = DateTime.now();
  Color color = const Color(0x00000000);
  String iconData = '0xe1b9';


  Jadval.fromJson(Map<String, dynamic> json) {
    tr = int.parse(json['tr'].toString());
    trBobo = int.parse(json['trBobo'].toString());
    nomi = json['nomi'].toString();
    time = DateTime.fromMillisecondsSinceEpoch(int.tryParse(json['time'].toString()) ?? 0);
    color = Color(int.tryParse(json['color'].toString()) ?? 0);
    iconData = json['iconData'].toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'tr': tr,
      'trBobo': trBobo,
      'nomi': nomi,
      'time': time.millisecondsSinceEpoch,
      'color': color.value,
      'iconData':iconData
    };
  }

  @override
  String toString() {
    return """  
      tr: $tr
      trBobo: $trBobo
      nomi: $nomi
      time: $time
      color: $color
      iconData: $iconData
""";
  }

  Future<int> insert() async {
    tr = await service.insert(toJson());
    Jadval.obektlar[tr] = this;
    return tr;
  }

  Future<void> delete() async {
    Jadval.obektlar.remove(tr);
    await service.delete(where: "tr='$tr'");
  }

  Future<void> update() async {
    Jadval.obektlar[tr] = this;
    await service.update(toJson(), where: "tr='$tr'");
  }
}



class JadvalService extends CrudService {
  @override
  JadvalService({super.prefix = ''}) : super("folderlar");

  static String createTable = """
  CREATE TABLE "folderlar" (
  "tr" INTEGER,
  "trBobo" INTEGER NOT NULL DEFAULT 0,
  "nomi" TEXT NOT NULL DEFAULT '',
  "time" INTEGER,
  "color" TEXT NOT NULL DEFAULT '',
  "iconData" TEXT NOT NULL DEFAULT '',
  PRIMARY KEY("tr" AUTOINCREMENT)
  );
  """;


  @override
  Future<void> update(Map map, {String? where})async {
    where = where == null ? "" : "WHERE $where";

    String updateClause = "";
    final List params = [];
    final values = map.keys;

    for (String value in values) {
      if (updateClause.isNotEmpty) updateClause += ", ";
      updateClause += "$value=?";
      params.add(map[value]);
    }
    final String sql = "UPDATE $table SET $updateClause$where";
    await db.execute(sql, tables: [table], params: params);
    debugPrint('JadvalService "update" method ishladi');
  }

  @override
  Future<void> delete({String? where}) async {
    where = where == null ? "" : "WHERE $where";
    await db.query("DELETE FROM $table $where");
    debugPrint('JadvalService "delete" method ishladi');
  }


  @override
  Future<int> insert(Map map) async {
    map['tr'] = (map['tr'] == 0) ? null : map['tr'];
    var insertM = await db.insert(map as Map<String,dynamic>, table);
    debugPrint('JadvalService "insert" method ishladi');
    return insertM;
  }

  @override
  Future<Map> select({String? where}) async {
    where = where == null ? "" : "WHERE $where";
    Map<int, dynamic> map = {};
    await for (final rows
    in db.watch("SELECT * FROM $table $where", tables: [table])) {
      for (final element in rows) {
        map[element['tr']] = element;
      }
      return map;
    }
    debugPrint("JadvalService select method ishladi");
    return map;
  }
}
