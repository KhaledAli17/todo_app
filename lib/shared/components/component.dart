import 'package:app_todo/shared/cubit/cubit.dart';
import 'package:conditional_builder/conditional_builder.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget defaultTextForm({
  required TextEditingController controller,
  required TextInputType inputType,
  required String label,
  required IconData prefix,
  required Function validate,
  Function? onTap,
  IconData? suffix,
  Function? onSubmit,
  Function? suffixPressed,
  bool isPassword = false,

}) =>
    TextFormField(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefix),
        suffixIcon: suffix != null
            ? IconButton(
            onPressed: (){suffixPressed!();},
            icon: Icon(suffix))
            : null,
        border: OutlineInputBorder(),
      ),
      keyboardType: inputType,
      onFieldSubmitted: (s){onSubmit!(s);},
      controller: controller,
      validator: (s){validate(s);},
      obscureText: isPassword,
      onTap: (){onTap!();},
    );

Widget buildItemTask(Map model, context) => Dismissible(
  key: Key(model['id'].toString()),
  child: Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      children: [
        CircleAvatar(
          radius: 40.0,
          child: Center(
            child: Text(
              '${model['time']}',
              style: const TextStyle(
                fontSize: 15.0,
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 15.0,
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${model['title']}',
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${model['date']}',
                style: const TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        IconButton(
            onPressed: () {
              ToDoCubit.get(context)
                  .updateDB(status: 'done', id: model['id']);
            },
            icon: const Icon(
              Icons.check_box,
              color: Colors.green,
            )),
        IconButton(
            onPressed: () {
              ToDoCubit.get(context)
                  .updateDB(status: 'archive', id: model['id']);
            },
            icon: const Icon(
              Icons.archive,
              color: Colors.grey,
            )),
      ],
    ),
  ),
  onDismissed: (direction) {
    ToDoCubit.get(context).deleteDB(
      id: model['id'],
    );
  },
);

Widget taskBuilder(@required List<Map> tasks) => ConditionalBuilder(
  condition: tasks.length > 0,
  builder: (context) => ListView.separated(
      itemBuilder: (context, index) => buildItemTask(tasks[index], context),
      separatorBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(
          left: 10.0,
          right: 10.0,
        ),
        child: Container(
          width: double.infinity,
          height: 1.0,
          color: Colors.grey[300],
        ),
      ),
      itemCount: tasks.length),
  fallback: (context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(
          Icons.menu,
          color: Colors.grey,
          size: 100.0,
        ),
        Text(
          'No Tasks Yeat, Please Add Tasks ',
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ],
    ),
  ),
);


   /* ConditionalBuilder(
  condition: tasks.length > 0,
  builder: (context) => ListView.separated(
      itemBuilder: (context, index) => buildItemTask(tasks[index], context),
      separatorBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(
          left: 10.0,
          right: 10.0,
        ),
        child: Container(
          width: double.infinity,
          height: 1.0,
          color: Colors.grey[300],
        ),
      ),
      itemCount: tasks.length),
  fallback: (context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(
          Icons.menu,
          color: Colors.grey,
          size: 100.0,
        ),
        Text(
          'No Tasks Yeat, Please Add Tasks ',
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ],
    ),
  ),
);
*/