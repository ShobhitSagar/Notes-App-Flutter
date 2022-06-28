import 'package:flutter/material.dart';
import 'package:notes_app/TaskList.dart';
import 'database_helper.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final tfController = TextEditingController();
  final dbHelper = DatabaseHelper();

  // final Future<List<Map<String, dynamic>>> _taskData = [] as Future<List<Map<String, dynamic>>>;

  var allIdList = [];
  var allComplList = [];
  var allTaskList = [];

  Future<List<Map<String, dynamic>>> allTasks() async {
    final alllist = await dbHelper.queryAllTask();
    allIdList = [];
    allComplList = [];
    allTaskList = [];
    for (var taskObj in alllist) {
      allIdList.add(taskObj['_id']);
      allComplList.add(taskObj['completed']);
      allTaskList.add(taskObj['task']);
    }
    return alllist;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
              top: 14.0, bottom: 14.0, left: 10.0, right: 10.0),
          child: Row(
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: tfController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.only(left: 10.0, right: 10.0),
                        labelText: 'Add Task',
                        hintText: 'Add a task...'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: SizedBox(
                  height: 47,
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          addTask();
                        });
                      },
                      child: const Text('Add')),
                ),
              )
            ],
          ),
        ),
        FutureBuilder(
          future: allTasks(),
          builder: (context, snapshot) {
            //
            // Waiting...
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  Text(
                    'Loading...',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              //
              // If has Error
              if (snapshot.hasError) {
                print('SnapshotHasError: $snapshot');
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      'No Data found!',
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ),
                );
              } else if (snapshot.hasData) {
                //
                // Actual Todo List
                print('SnapshotHasData: ${snapshot.data}');
                if (allTaskList.isEmpty) {
                  return const Center(
                      child: Text(
                    'No Task!!!',
                    style: TextStyle(fontSize: 16),
                  ));
                }
                return TaskList(
                  taskDataLength: allTaskList.length,
                  taskDataIds: allIdList,
                  taskDataComp: allComplList,
                  taskDataTasks: allTaskList,
                );
              } else {
                //
                // No Data
                return const Center(
                  child: Text(
                    'Nothing to do!',
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                );
              }
              // If nothing
            } else {
              return Center(
                child: Text(
                  'State: ${snapshot.connectionState}',
                  style: const TextStyle(color: Colors.blue, fontSize: 16),
                ),
              );
            }
          },
        )
      ],
    );
  }

  void addTask() async {
    final text = tfController.text;
    if (text.isEmpty) return print('Please enter a task.');
    Map<String, dynamic> row = {
      DatabaseHelper.colCompleted: 0,
      DatabaseHelper.colTask: tfController.text
    };
    final id = await dbHelper.insert(row);
    tfController.clear();
  }
}

// class Task {
//   final int id;
//   final bool completed;
//   final String task;

//   const Task({required this.id, required this.completed, required this.task});
// }
