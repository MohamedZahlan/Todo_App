import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_projects/layout/news_app/Cubit/cubit.dart';
import 'package:flutter_projects/layout/todo_app/cubit/cubit.dart';
import 'package:flutter_projects/layout/todo_app/cubit/states.dart';
import 'package:intl/intl.dart';


class TodoLayout extends StatelessWidget {
   TodoLayout({Key? key}) : super(key: key);

  var scaffold = GlobalKey<ScaffoldState>();
  var form = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=>TodoCubit()..createDataBase(),
      child: BlocConsumer<TodoCubit, TodoStates>(
        listener: (context, state){},
        builder: (context, state){
          var cubit = TodoCubit.get(context);
          return Scaffold(
            key: scaffold,
            appBar: AppBar(
              title:  Text(
                  cubit.titles[cubit.currentIndex]
              ),
              actions: [
                IconButton(
                    onPressed: (){
                      NewsCubit.get(context).changeAppMode();
                    },
                    icon:const Icon(Icons.dark_mode_outlined)
                )
              ],
              //backgroundColor: Colors.teal,
            ),
            body: ConditionalBuilder(
                condition: state is! TodoLoadingState,
                builder: (context)=>cubit.screens[cubit.currentIndex],
                fallback: (context)=>const Center(child: CircularProgressIndicator())
            ),
            bottomNavigationBar: BottomNavigationBar(
                selectedItemColor: Colors.teal,
                currentIndex: cubit.currentIndex,
                onTap: (index){

                  cubit.changescreen(index);
                },
                items: cubit.bottomNav
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.teal,
              onPressed: () {
                if(cubit.isbottomsheetshown) {
                  if(form.currentState!.validate()){
                    cubit.insertToDataBase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text,
                    ).then((value){
                      Navigator.pop(context);
                      titleController.clear();
                      timeController.clear();
                      dateController.clear();
                    });
                  }
                }else
                {
                  scaffold.currentState!.showBottomSheet((context) => Container(
                    color: Colors.black,
                    padding:const EdgeInsets.all(20),
                    child: Form(
                      key: form,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: TextFormField(
                              decoration:  InputDecoration(
                                  labelText: 'Task Title',
                                  prefixIcon: const Icon(Icons.title,//color: Colors.teal,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )
                              ),
                              controller: titleController,
                              validator: (value) {
                                if(value!.isEmpty){
                                  return "Title must not be empty";
                                }
                                return null;
                              },
                              keyboardType: TextInputType.text,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: TextFormField(
                              decoration:  InputDecoration(
                                  labelText: 'Task Time',
                                  prefixIcon: const Icon(Icons.watch_later,
                                    //color: Colors.teal,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )
                              ),
                              controller: timeController,
                              validator: (value) {
                                if(value!.isEmpty){
                                  return "Time must not be empty";
                                }
                                return null;
                              },
                              keyboardType: TextInputType.datetime,
                              onTap: (){
                                showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                ).then((value){
                                  timeController.text = value!.format(context);
                                });
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: TextFormField(
                              decoration:  InputDecoration(
                                  labelText: 'Task Date',
                                  prefixIcon: const Icon(Icons.date_range,//color: Colors.teal,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )
                              ),
                              controller: dateController,
                              validator: (value) {
                                if(value!.isEmpty){
                                  return "Date must not be empty";
                                }
                                return null;
                              },
                              keyboardType: TextInputType.datetime,
                              onTap: (){
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2025),
                                ).then((value){
                                  dateController.text = DateFormat.yMMMd().format(value!);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  ).closed.then((value){
                    cubit.ChangeBottomSheet(show: false, icon: Icons.edit_note);
                  });
                  cubit.ChangeBottomSheet(
                      show: true,
                      icon: Icons.add_task);
                }

              },
              child:  Icon(
                cubit.fabicon,
              ),
            ),
          );
        },
      ),
    );
  }
}








//(context) =>Container(
//                           color: Colors.grey[100],
//                           padding: const EdgeInsets.all(20.0),
//                           child: Form(
//                            key: formkey,
//                            child: Column(
//                            mainAxisSize: MainAxisSize.min,
//                              children: [
//                              TextFormField(
//                                controller: titleController,
//                                keyboardType: TextInputType.text,
//                                decoration:  InputDecoration(
//                                  prefixIcon: const Icon(Icons.title),
//                                  labelText: "Task Title",
//                                  border: OutlineInputBorder(
//                                      borderRadius: BorderRadius.circular(10)
//                                  ),
//                                ),
//                                validator: (value){
//                                  if(value!.isEmpty){
//                                    return "title must not be empty";
//                                  }
//                                  return null;
//                                },
//
//                              ),
//                              const SizedBox(
//                                height: 10,
//                              ),
//                              TextFormField(
//                                controller: timeController,
//                                keyboardType: TextInputType.text,
//                                decoration:  InputDecoration(
//                                  prefixIcon: const Icon(Icons.watch_later_rounded),
//                                  labelText: "Task Time",
//                                  border: OutlineInputBorder(
//                                      borderRadius: BorderRadius.circular(10)
//                                  ),
//                                ),
//                                validator: (value){
//                                  if(value!.isEmpty){
//                                    return "time must not be empty";
//                                  }
//                                  return null;
//                                },
//                                onTap: (){
//                                  showTimePicker(
//                                      context: context,
//                                      initialTime: TimeOfDay.now()).then((value) {
//                                    timeController.text = value!.format(context);
//                                  });
//                                },
//                              ),
//                              const SizedBox(
//                                height: 10,
//                              ),
//                              TextFormField(
//                                controller: dateController,
//                                keyboardType: TextInputType.text,
//                                decoration:  InputDecoration(
//                                  prefixIcon: const Icon(Icons.date_range),
//                                  labelText: "Task date",
//                                  border: OutlineInputBorder(
//                                      borderRadius: BorderRadius.circular(10)
//                                  ),
//                                ),
//                                validator: (value){
//                                  if(value!.isEmpty){
//                                    return "date must not be empty";
//                                  }
//                                  return null;
//                                },
//                                onTap: (){
//                                  showDatePicker(
//                                      context: context,
//                                      initialDate: DateTime.now(),
//                                      firstDate: DateTime.now(),
//                                      lastDate: DateTime(2025)).then((value){
//                                    dateController.text = DateFormat.yMMMd().format(value!);
//                                  });
//                                },
//                              ),
//                            ],
//                           ),
//                       ),
//                         )).closed.then((value){
//                     cubit.changebottomicon(
//                       show: false,
//                       Icon: Icons.edit,
//                     );
