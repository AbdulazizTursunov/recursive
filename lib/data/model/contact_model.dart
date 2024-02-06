

import 'package:flutter/material.dart';
import 'package:recursive/data/db/crud_service.dart';
import 'package:recursive/data/db/db_initialize.dart';

class ContactModel{
  ContactModel();

  static CrudService service = ContactService();
  static Map<int, ContactModel> obektlar = {};

  int tr=0;
  String contact = '';
  String name='';

  ContactModel.fromJson(Map<String, dynamic> json) {
    tr = int.parse(json['tr'].toString());
    contact = json['contact'].toString();
    name = json['name'].toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'tr': tr,
      'contact': contact,
      'name': name,
    };
  }

  @override
  String toString() {
    return """  
      tr: $tr
      contact: $contact
      name: $name
""";
  }

  Future<int> insert() async {
    tr = await service.insert(toJson());
    ContactModel.obektlar[tr] = this;
    return tr;
  }

  Future<void> delete() async {
    ContactModel.obektlar.remove(tr);
    await service.delete(where: "tr='$tr'");
  }

  Future<void> update() async {
    ContactModel.obektlar[tr] = this;
    await service.update(toJson(), where: "tr='$tr'");
  }
}



class ContactService extends CrudService {
  @override
  ContactService({super.prefix = ''}) : super("contacts");

  static String createContactTable = """
  CREATE TABLE "contacts" (
  "tr" INTEGER,
  "contact" TEXT NOT NULL DEFAULT '',
  "name" TEXT NOT NULL DEFAULT '',
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
    debugPrint('ContactService "update" method ishladi');
  }

  @override
  Future<void> delete({String? where}) async {
    where = where == null ? "" : "WHERE $where";
    await db.query("DELETE FROM $table $where");
    debugPrint('ContactService "delete" method ishladi');
  }


  @override
  Future<int> insert(Map map) async {
    map['tr'] = (map['tr'] == 0) ? null : map['tr'];
    var insertM = await db.insert(map as Map<String,dynamic>, table);
    debugPrint('ContactService "insert" method ishladi');
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
    debugPrint("ContactService select method ishladi");
    return map;
  }
}
