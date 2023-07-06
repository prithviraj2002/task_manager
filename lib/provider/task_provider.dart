import 'package:flutter/material.dart';
import 'package:task_manager/database/sql_database.dart';
import 'package:task_manager/model/task_model.dart';

class TaskProvider extends ChangeNotifier{

  Future<List<Task>> getTaskByCategory(String category) async{
    List<Task> tasks = [];
    await Db.getTasks().then((value){
      for(Task t in value){
        if(t.Category == category){
          tasks.add(t);
        }
      }
    });
    return tasks;
  }

  Future<List<Task>> getTaskByProgress(double progress) async{
    List<Task> notStarted = [];
    List<Task> inProgress = [];
    List<Task> completed = [];

    await Db.getTasks().then((value){
      for(Task t in value){
        if(t.progress == 0){
          notStarted.add(t);
        }
        if(t.progress > 0 && t.progress < 100){
          inProgress.add(t);
        }
        if(t.progress == 100){
          completed.add(t);
        }
      }
    });
    if(progress == 100){
      return completed;
    }
    else if(progress > 0 && progress < 100){
      return inProgress;
    }
    else{
      return notStarted;
    }
  }
}