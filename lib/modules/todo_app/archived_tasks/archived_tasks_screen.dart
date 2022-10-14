import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_projects/layout/todo_app/cubit/cubit.dart';
import 'package:flutter_projects/layout/todo_app/cubit/states.dart';
import 'package:flutter_projects/shared/shared.components/components.dart';

class ArchivedScreen extends StatelessWidget {
  const ArchivedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit, TodoStates>(
      listener: (context, state){},
      builder: (context, state){
        var newTask = TodoCubit.get(context).archivedTasks;
        return tasksBuilder(
            newTask: newTask
        );
      },
    );
  }
}
