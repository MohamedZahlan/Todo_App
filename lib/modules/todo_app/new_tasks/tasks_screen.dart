import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_projects/layout/todo_app/cubit/cubit.dart';
import 'package:flutter_projects/layout/todo_app/cubit/states.dart';
import 'package:flutter_projects/shared/shared.components/components.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit, TodoStates>(
      listener: (context, state){},
      builder: (context, state){
        var newTask = TodoCubit.get(context).newTasks;
        return tasksBuilder(
          newTask: newTask
        );
      },
    );
  }
}
