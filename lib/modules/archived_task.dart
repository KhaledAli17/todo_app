import 'package:app_todo/shared/components/component.dart';
import 'package:app_todo/shared/cubit/cubit.dart';
import 'package:app_todo/shared/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ArchivedTask extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToDoCubit, ToDoStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = ToDoCubit.get(context).archivedTasks;
        return taskBuilder(tasks);
      },
    );
  }
}
