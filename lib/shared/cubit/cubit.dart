import 'package:app_todo/modules/archived_task.dart';
import 'package:app_todo/modules/done_task.dart';
import 'package:app_todo/modules/new_task.dart';
import 'package:app_todo/shared/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

class ToDoCubit extends Cubit<ToDoStates> {
  ToDoCubit() : super(ToDoInitialState());

  static ToDoCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> screens = [
    NewTask(),
    DoneTask(),
    ArchivedTask(),
  ];
  List<String> titles = [
    'New',
    'Done',
    'Archived',
  ];

  void changeIndex(int index) {
    currentIndex = index;
    emit(ChangeBottomNavBar());
  }

  late Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print('database created');
        database
            .execute(
                'CREATE TABLE Task(id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('error${error.toString()}');
        });
      },
      onOpen: (database) {
        getData(database);
        print('database opened');
        print(database);
      },
    ).then((value) {
      database = value;
      emit(ChangeCreateDB());
    });
  }

  insertDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    await database.transaction((txn) => txn
            .rawInsert(
                'INSERT INTO Task (title,date,time,status) VALUES ("$title","$date","$time","new")')
            .then((value) {
          print('data inserted');
          emit(ChangeInsertDB());

          getData(database);
          emit(ChangeGetDB());
        }).catchError((error) {
          print('ERROR WHEN INSERT RECORD ${error.toString()}');
        }));
  }

  void getData(database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];

    emit(ChangeGetLoadingDB());
    database.rawQuery('SELECT * FROM Task').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          archivedTasks.add(element);
        }
      });

      emit(ChangeGetDB());
    });
  }

  void updateDB({
    required String status,
    required int id,
  }) async {
    database.rawUpdate(
      'UPDATE Task SET status = ?  WHERE id = ? ',
      ['$status', id],
    ).then((value) {
      getData(database);
      emit(ChangeUpdateDB());
    });
  }

  void deleteDB({
    required int id,
  }) async {
    database.rawDelete(
      'DELETE FROM Task WHERE id = ?  ',
      [id],
    ).then((value) {
      getData(database);
      emit(ChangeDeleteDB());
    });
  }

  IconData flatIcon = Icons.edit;
  bool flatIconShow = false;

  void flatIconChange({
    required bool isShow,
    required IconData icon,
  }) {
    flatIconShow = isShow;
    flatIcon = icon;
    emit(ChangeFlatIcon());
  }
}
