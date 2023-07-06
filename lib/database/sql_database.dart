import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_manager/model/task_model.dart';

class Db{
  static Future<Database> getDb() async{
    WidgetsFlutterBinding.ensureInitialized();
    final path = await getDatabasesPath();

    final database = openDatabase(
        join(path, 'tasks_database.db'),
        onCreate: (db, version){
          return db.execute("CREATE TABLE tasks(ID INTEGER PRIMARY KEY, TITLE TEXT, DESC TEXT, PROGRESS INTEGER, CATEGORY TEXT)");
        },
        version: 1
    );
    return database;
  }

  static Future<void> addTask(Task task) async{
    final db = await getDb();
    await db.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> delTask(int id) async{
    final db = await getDb();
    await db.delete(
        'tasks',
        where: 'id = ?',
        whereArgs: [id]
    );
  }

  static Future<void> updateTask(Task task) async{
    final db = await getDb();
    await db.update(
        'tasks',
        task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  static Future<List<Task>> getTasks() async{
    final db = await getDb();

    final List<Map<String, dynamic>> tasks = await db.query('tasks');
    return List.generate(
        tasks.length, (index) {
      return Task(title: tasks[index]['TITLE'], id: tasks[index]['ID'], Category: tasks[index]['CATEGORY'], progress: tasks[index]['PROGRESS']);
    });
  }
}