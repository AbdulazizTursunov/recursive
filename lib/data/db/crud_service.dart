abstract class CrudService{
  late final String prefix;
  final String table;

  CrudService(this.table,{this.prefix=''});

  Future<Map<dynamic,dynamic>> select ({String? where});

  Future<int> insert(Map map);

  Future<void> delete ({String? where});

  Future<void> update(Map map,{String? where});
}