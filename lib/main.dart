import 'package:app_todo/layout/home_layout.dart';
import 'package:app_todo/shared/bloc_observer.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

void main() {

  Bloc.observer = MyBlocObserver();
  runApp(const ToDo());
}

class ToDo extends StatelessWidget {
  const ToDo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

