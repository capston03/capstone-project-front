import 'dart:async';
import 'dart:io';
import 'package:capstone_android/db/UserInfo.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// 일단 유저 정보 관련 Sqlite관련 파일
/// 일단은 대부분 여기서 관리
class ManageSqlflite {
  static Database? _database;
  ManageSqlflite._privateConstructor();
  static final ManageSqlflite singleton = ManageSqlflite._privateConstructor();
  Future<Database> get database async => _database??await _initDatabase();

  Future<Database> _initDatabase() async{
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path,'UserInfo.db');
    return await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async{
      await db.execute('''
        CREATE TABLE userinfo(
          googleID TEXT PRIMARY KEY,
          nick TEXT,
          updateImage TEXT,
        )
      ''');
  }
  //insert
  Future<int> insert(UserInfo info) async{
    Database db = await singleton.database;
    return await db.insert('userinfo', info.toMap());
  }
  //read
  Future<List<UserInfo>> select() async{
    Database db = await singleton.database;
    var userinfo = await db.query('userinfo');
    List<UserInfo> groceryList = userinfo.isNotEmpty
        ? userinfo.map((c) => UserInfo.fromMap(c)).toList()
        : [];
    return groceryList;
  }
  //업데이트 -> 추후 수정예정
  Future<int> update(UserInfo userInfo) async {
    Database db = await singleton.database;
    return await db.update('groceries', userInfo.toMap(),
        where: 'googleID = ?', whereArgs: [userInfo.googleID]);
  }
  Future<int> remove(String googleID) async {
    Database db = await singleton.database;
    return await db.delete('userinfo', where: 'googleID = ?', whereArgs: [googleID]);
  }

  Future<int> updateImageTime(DateTime time, String googleID) async{
    Database db = await singleton.database;
    String updatingTime = time.toIso8601String(); //decoding DateTime.parse(time);
    return db.rawUpdate(
      'UPDATE userinfo SET updateImage=? WHERE googleID=?',
      [updatingTime,googleID]
    );
  }

  //db 닫기
  Future closeDB(Database db) async {
    await db.close();
  }

}