
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_projects/layout/todo_app/cubit/states.dart';
import 'package:flutter_projects/shared/network/local/cache_helper.dart';
import 'package:sqflite/sqflite.dart';
import '../../../modules/todo_app/archived_tasks/archived_tasks_screen.dart';
import '../../../modules/todo_app/new_tasks/tasks_screen.dart';
import '../../../modules/todo_app/done_tasks/done_tasks_screen.dart';

class TodoCubit extends Cubit<TodoStates>
{
  TodoCubit() : super(TodoInitialState());

  static TodoCubit get(context)=> BlocProvider.of(context);

  int currentIndex = 0;

  // الليست دي بستخدمها علشان اقدر اعرض النص في الاب بار الخاص بكل اسكرينه
  List<String> titles = [
    "New Task" ,
    "Done Task" ,
    "Archived Task" ,
  ];

  //  الليست دي بستخدمها علشان اقدر اعرض اسكرينه واتنقل ما بينهم
  List<Widget> screens = [
    const TaskScreen(),
    const DoneScreen(),
    const ArchivedScreen()
  ];

  List<BottomNavigationBarItem> bottomNav =
  [
    const BottomNavigationBarItem(
        icon: Icon(
          Icons.task_alt
        ),
      label: "Tasks"
    ),
    const BottomNavigationBarItem(
        icon: Icon(
          Icons.done_outline_sharp
        ),
      label: "Done"
    ),
    const BottomNavigationBarItem(
        icon: Icon(
          Icons.archive_rounded
        ),
      label: "Archived"
    ),
  ];

  void changescreen(int index) //=> من  خلالها بقدر اتنقل بين الاسكرينات
  {
    currentIndex = index;
    emit(TodoChangeScreenState());
  }
  late Database database;

  Future createDataBase() async{
    return openDatabase(
        'todo.db',
      version: 1,
      onCreate: (database, version){
          print('database created');
          database.execute
            ('CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, time TEXT, date TEXT, status TEXT)'
          ).then((value){
            print('Table Created');
          }).catchError((error){
            print('we found error when created table ${error.toString()}');
          });
      },
      onOpen: (database){
          print('database opend');
          getDataFromDataBase(database);
      }
    ).then((value){
      database = value;
      emit(TodoCreateDataBase());
    });
  }

  Future insertToDataBase({
  required String title,
  required String time,
  required String date,
})async {
    await database.transaction((txn)async{
      return await txn.rawInsert(
          'INSERT INTO tasks ("title","time","date","status") VALUES("$title", "$time","$date","new")'
      ).then((value){
        print('$value Inserted Successfully');
        emit(TodoInsertToDataBase());
        getDataFromDataBase(database);
      }).catchError((error){
        print("some error${error.toString()}");
      });
    });
  }
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  Future getDataFromDataBase(database)async{
     newTasks = [];
     doneTasks = [];
     archivedTasks = [];
    emit(TodoLoadingState());
    return await database.rawQuery('SELECT * FROM tasks').then((value){
      emit(TodoGetFromDataBase());
      value.forEach((element){
        if(element['status']== "new"){
          newTasks.add(element);
        }else if(element["status"]== "done"){
          doneTasks.add(element);
        }else{
          archivedTasks.add(element);
        }
      });
    });
  }

  void updateDataBase({
  required String status,
  required int id,
}){
    database.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
        [status, id]).then((value){
          emit(TodoUpdateToDataBaseState());
          getDataFromDataBase(database);
    });
  }

  void deleteFromDataBase({
    required int id,
  }){
    database.rawDelete(
        'DELETE From tasks WHERE id = ?',
        [ id]).then((value){
      emit(TodoDeleteFromDataBaseState());
      getDataFromDataBase(database);
    });
  }

  bool isbottomsheetshown = false;
  IconData fabicon = Icons.edit_note;

  void ChangeBottomSheet({
  required bool show,
  required IconData icon,
}){
    fabicon = icon;
    isbottomsheetshown = show;
    emit(TodoChangeBottomSheetState());
  }
   bool isDark = false;
  void changeTodoMode(){
    isDark = !isDark;
    CacheHelper.setBoolean(key: 'isDark', value: isDark).then((value){
      emit(TodoChangeAppModeState());
    });
  }

}