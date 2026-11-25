import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';
import 'package:sqlite3/wasm.dart';

QueryExecutor openDatabaseConnection() {
  return LazyDatabase(() async {
    final fs = await IndexedDbFileSystem.open(dbName: 'pfm_budget_app');
    final sqlite3 = await WasmSqlite3.loadFromUrl(Uri.parse('sqlite3.wasm'));
    sqlite3.registerVirtualFileSystem(fs, makeDefault: true);
    return WasmDatabase(
      sqlite3: sqlite3,
      path: '/pfm_budget_app.db',
      fileSystem: fs,
    );
  });
}
