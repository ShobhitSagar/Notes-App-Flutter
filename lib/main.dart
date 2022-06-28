import 'package:flutter/material.dart';
import 'package:notes_app/AddTask.dart';
// import 'package:notes_app/CounterPage.dart';
import 'MyHomePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Notes App'),
        ),
        body: const AddTask(),
      ),
    );
  }
}
