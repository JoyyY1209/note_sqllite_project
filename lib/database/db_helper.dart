import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
class DatabaseHelper{

  static const databaseName = 'note.db';
  static const databaseVersion = 1;

  //tablename
  static const tableNotes = 'notes';

  //colums names

  static const columnId = 'id';
  static const columnTitle = 'title';
  static const columnDescription = 'description';

  //creating single intace of DatabaseHelper
  DatabaseHelper.privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper.privateConstructor();

  //database object
  static Database? mydb;

  Future<Database?> get database async{
    if(mydb!=null) return mydb;
    mydb=await initDatabase();
    return mydb;
  }

  initDatabase()async{
    String path = join(await getDatabasesPath(),databaseName);
    return await openDatabase(path,version: databaseVersion,onCreate: createTables);
  }

  Future createTables(Database db,int version)async{
    await db.execute(
      """
      CREATE TABLE $tableNotes(
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnTitle TEXT NOT NULL,
      $columnDescription TEXT NOT NULL
      )
      
      """
    );
  }

  //get all data from db  
  Future<List<Map<String,dynamic>>> getAllData() async{
    Database? db = await instance.database;
    return await db!.query(tableNotes,orderBy: "$columnId DESC");

    //we can also use raw query
    // List<Map<String,dynamic>> note = await db!.rawQuery('SELECT * FROM notes');

    //return note;
  }

  //insert data into database
  Future<int> insertData(Map<String,dynamic> map)async{
    Database? db = await instance.database;
    return await db!.insert(tableNotes, map);
  }

  //upadte note into database
  Future<int> upadteNote(Map<String,dynamic> map,int id)async{
    Database? db = await instance.database;
    return await db!.update(tableNotes, map,where: '$columnId = ? ',whereArgs: [id] );

    //we can also use raw query
    // List<Map<String,dynamic>> note =  await db!.rawQuery('SELECT * FROM notes WHERE userId = ?',[userId]);

    //return note;

    //
  }

  //delete note in database

  Future<int> deleteNote(int id)async{
    Database? db = await instance.database;
    return await db!.delete(tableNotes,where: '$columnId = ? ',whereArgs: [id]);
  }


}