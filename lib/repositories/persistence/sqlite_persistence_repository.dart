import 'dart:async';

import 'package:invest_analize/entities/aquisition_entity.dart';
import 'package:invest_analize/entities/symol_entity.dart';
import 'package:invest_analize/entities/value_entity.dart';
import 'package:invest_analize/repositories/persistence/persistence_repository.dart';
import 'package:sqflite/sqflite.dart' as sqFlite;

const PERSISTENCE_DB_PATH = 'persistence_db';
const PERSISTENCE_DB_VERSION = 5;
const AQUISITIONS_TABLE = 'aquisitions';
const SYMBOLS_TABLE = 'symbols';
const VALUES_TABLE = 'aquisitions_values';

class SqLitePersistenceRepository implements PersistenceRepository {
  late sqFlite.Database db;
  @override
  Future<void> init() async {
    db = await sqFlite.openDatabase(PERSISTENCE_DB_PATH,
        version: PERSISTENCE_DB_VERSION, onCreate: _onCreateDatabase);
  }

  FutureOr<void> _onCreateDatabase(sqFlite.Database db, int version) async {
    await db.execute(
        'CREATE TABLE $AQUISITIONS_TABLE (id INTEGER PRIMARY KEY AUTOINCREMENT, symbol TEXT'
        ', qnt REAL, created_at INTEGER)');
    await db.execute(
        'CREATE TABLE $SYMBOLS_TABLE (symbol TEXT PRIMARY KEY, description TEXT, logo TEXT)');
    await db.execute(
        'CREATE TABLE $VALUES_TABLE (id INTEGER PRIMARY KEY AUTOINCREMENT, price REAL,'
        ' last_update INTEGER, reference TEXT, change REAL, percent_change REAL)');
  }

  @override
  Future<SymbolEntity> insertAquisition(AcquisitionEntity aquisition,
      SymbolEntity symbol, ValueEntity value) async {
    return await db.transaction<SymbolEntity>((transaction) async {
      await transaction.insert(SYMBOLS_TABLE, symbol.toSqfliteMap(),
          conflictAlgorithm: sqFlite.ConflictAlgorithm.ignore);

      await transaction.insert(AQUISITIONS_TABLE, aquisition.toSqfliteMap());

      await transaction.insert(
        VALUES_TABLE,
        value.toSqfliteMap()..['reference'] = symbol.symbol,
      );
      return symbol
        ..aquisition = aquisition
        ..value = value;
    });
  }

  @override
  Future<List<SymbolEntity>> getAquisitionsWallet() async {
    final transaction =
        await db.transaction<List<SymbolEntity>>(_symbolsTransaction);
    return transaction;
  }

  Future<List<SymbolEntity>> _symbolsTransaction(
      sqFlite.Transaction transaction) async {
    // get all symbols
    final symbols = await transaction.query(SYMBOLS_TABLE);
    // get acquisitoin grouped by symbol get only maximum id
    final aquisition = await transaction
        .query(AQUISITIONS_TABLE, where: '''id IN (SELECT MAX(id) AS id
             FROM $AQUISITIONS_TABLE 
             GROUP BY symbol) ''');
    // get value grouped by reference get only maximum id
    final values = await transaction
        .query(VALUES_TABLE, where: '''id IN (SELECT MAX(id) AS id
             FROM $VALUES_TABLE 
             GROUP BY reference) ''');
    //create a list of acquisitions
    final aquisitionsList =
        aquisition.map((e) => AcquisitionEntity.fromSqFliteQuery(e)).toList();
    final valuesList =
        values.map((e) => ValueEntity.fromSqFliteQuery(e)).toList();

    final symbolList = symbols.map((map) {
      final symbol = SymbolEntity.fromSqfliteQuery(map);
      symbol.aquisition = aquisitionsList
          .firstWhere((element) => element.symbol == symbol.symbol);
      symbol.value = valuesList
          .firstWhere((element) => element.reference == symbol.symbol);
      return symbol;
    }).toList();
    return symbolList;
  }

  @override
  Future<SymbolEntity> deletSymbol(SymbolEntity symbolEntity) async {
    db.transaction((transaction) async {
      await transaction.delete(SYMBOLS_TABLE,
          where: 'symbol = ? ', whereArgs: [symbolEntity.symbol]);

      await transaction.delete(AQUISITIONS_TABLE,
          where: 'symbol = ?', whereArgs: [symbolEntity.symbol]);

      await transaction.delete(VALUES_TABLE,
          where: 'reference = ? ', whereArgs: [symbolEntity.symbol]);
      return;
    });
    return symbolEntity;
  }

  @override
  Future<ValueEntity> insertValue(ValueEntity value) async {
    await db.insert(VALUES_TABLE, value.toSqfliteMap());
    return value;
  }
}
