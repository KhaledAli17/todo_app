
import 'package:app_todo/shared/components/component.dart';
import 'package:app_todo/shared/cubit/cubit.dart';
import 'package:app_todo/shared/cubit/states.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class Home extends StatelessWidget {
 // const Home({Key? key}) : super(key: key);

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  void clearText(){
    titleController.clear();
    timeController.clear();
    dateController.clear();
  }

  @override
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();
    var formKey = GlobalKey<FormState>();


      return BlocProvider(
        create: (BuildContext context) => ToDoCubit()..createDatabase(),
        child: BlocConsumer<ToDoCubit, ToDoStates>(
          listener: (BuildContext context, ToDoStates state) {
            if(state is ChangeInsertDB)
            {
              Navigator.pop(context);
            }
          },
          builder: (BuildContext context, ToDoStates state) {
            ToDoCubit cubit = ToDoCubit.get(context);

            return Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                title: Text(
                  cubit.titles[cubit.currentIndex],
                ),
              ),
              body: ConditionalBuilder(
                condition: state is! ChangeGetLoadingDB,
                builder: (context) => cubit.screens[cubit.currentIndex],
                fallback: (context) => Center(child: CircularProgressIndicator()),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  if (cubit.flatIconShow)
                  {
                    if (formKey.currentState!.validate())
                    {
                      cubit.insertDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text,
                      );
                    }
                  } else
                  {
                    scaffoldKey.currentState!
                        .showBottomSheet(
                          (context) => Container(
                        color: Colors.white,
                        padding: EdgeInsets.all(
                          20.0,
                        ),
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              defaultTextForm(
                                controller: titleController,
                                inputType: TextInputType.text,
                                validate: (String value) {
                                  if (value.isEmpty) {
                                    return 'title must not be empty';
                                  }

                                  return null;
                                },
                                label: 'Task Title',
                                prefix: Icons.title,
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              defaultTextForm(
                                controller: timeController,
                                inputType: TextInputType.datetime,
                                onTap: () {
                                  showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  ).then((value) {
                                    timeController.text =
                                        value!.format(context).toString();
                                    print(value.format(context));
                                  });
                                },
                                validate: (String value) {
                                  if (value.isEmpty) {
                                    return 'time must not be empty';
                                  }

                                  return null;
                                },
                                label: 'Task Time',
                                prefix: Icons.watch_later_outlined,
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              defaultTextForm(
                                  controller: dateController,
                                  inputType: TextInputType.datetime,
                                  label: 'Task Date',
                                  prefix: Icons.calendar_today,
                                  validate: (String value) {
                                    if (value.isEmpty) {
                                      return 'date must not be empty';
                                    }
                                    return null;
                                  },
                                  onTap: () {
                                    showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate:
                                        DateTime.parse('2021-12-31'))
                                        .then((value) {
                                      dateController.text =
                                          DateFormat.yMMMd().format(value!);
                                      print(DateFormat.yMMMd().format(value));
                                    });
                                  }),
                            ],
                          ),
                        ),
                      ),
                      elevation: 20.0,
                    )
                        .closed
                        .then((value)
                    {
                      cubit.flatIconChange(
                        isShow: false,
                        icon: Icons.edit,
                      );
                    });

                    cubit.flatIconChange(
                      isShow: true,
                      icon: Icons.add,
                    );
                  };
                  clearText();

                },
                child: Icon(
                  cubit.flatIcon,
                ),
              ),
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: cubit.currentIndex,
                onTap: (index) {
                  cubit.changeIndex(index);
                },
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.menu,
                    ),
                    label: 'Tasks',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.check_circle_outline,
                    ),
                    label: 'Done',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.archive_outlined,
                    ),
                    label: 'Archived',
                  ),
                ],
              ),
            );
          },
        ),
      );
  }
}
