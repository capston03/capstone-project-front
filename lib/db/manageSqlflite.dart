import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:capstone_android/db/thumbnail.dart';
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
    String path = join(documentsDirectory.path,'ThumbNail.db');
    return await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async{
      await db.execute('''
        CREATE TABLE thumbnail(
          identifier INT PRIMARY KEY,
          title TEXT,
          content TEXT,
          uploader_gmail_id TEXT,
          upload_time TEXT,
          beacon_mac TEXT,
          heart_rate INT
        )
      ''');
  }
  //insert
  Future<int> insert(ThumbNail info) async{
    Database db = await singleton.database;
    return await db.insert('thumbnail', info.toMap());
  }


  Future<List<Map<String, Object?>>> selectAll() async{
    Database db = await singleton.database;
    return db.rawQuery('SELECT * FROM thumbnail');
  }

  //read
  Future<List<ThumbNail>> select() async{
    Database db = await singleton.database;
    var thumbnail = await db.query('thumbnail');
    List<ThumbNail> groceryList = thumbnail.isNotEmpty
        ? thumbnail.map((c) => ThumbNail.fromMap(c)).toList()
        : [];
    return groceryList;
  }

  Future<List<ThumbNail>> selectOne(int identifier) async{
    Database db = await singleton.database;
    var result = await db.rawQuery('SELECT * FROM thumbnail WHERE identifier=?',[identifier]);
    List<ThumbNail> data = result.isNotEmpty
        ? result.map((c)=>ThumbNail.fromMap(c)).toList():[];
    return data;

  }

  // //업데이트 -> 추후 수정예정
  // Future<int> update(ThumbNail userInfo) async {
  //   Database db = await singleton.database;
  //   return await db.update('groceries', userInfo.toMap(),
  //       where: 'googleID = ?', whereArgs: [userInfo.googleID]);
  // }
  Future remove() async {
    Database db = await singleton.database;
    await db.rawDelete("DELETE FROM thumbnail");
  }

  // Future<int> updateImageTime(DateTime time, String googleID) async{
  //   Database db = await singleton.database;
  //   String updatingTime = time.toIso8601String(); //decoding DateTime.parse(time);
  //   return db.rawUpdate(
  //     'UPDATE userinfo SET updateImage=? WHERE googleID=?',
  //     [updatingTime,googleID]
  //   );
  // }

  //db 닫기
  Future closeDB(Database db) async {
    await db.close();
  }

}