import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'database_helper.dart';

class TaskList extends StatefulWidget {
  final taskDataLength;
  final taskDataIds;
  final taskDataComp;
  final taskDataTasks;

  const TaskList(
      {required this.taskDataLength,
      required this.taskDataIds,
      required this.taskDataComp,
      required this.taskDataTasks});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  final dbHelper = DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.taskDataLength,
        itemBuilder: ((context, index) {
          return CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(
              '${widget.taskDataTasks[index]}',
              style: TextStyle(
                  decoration: widget.taskDataComp[index] == 1
                      ? TextDecoration.lineThrough
                      : TextDecoration.none),
            ),
            value: widget.taskDataComp[index] == 1 ? true : false,
            activeColor: Colors.grey,
            onChanged: (bool? value) {
              isChecked(value, index);
            },
            secondary: IconButton(
                onPressed: () {
                  delete(index);
                },
                icon: const Icon(Icons.delete)),
          );
        }),
      ),
    );
  }

  void isChecked(bool? checked, int i) {
    if (checked != null && checked) {
      Map<String, dynamic> row = {
        DatabaseHelper.colId: widget.taskDataIds[i],
        DatabaseHelper.colCompleted: 1,
        DatabaseHelper.colTask: widget.taskDataTasks[i]
      };
      dbHelper.update(row);

      setState(() {
        widget.taskDataComp[i] = 1;
      });
    } else {
      Map<String, dynamic> row = {
        DatabaseHelper.colId: widget.taskDataIds[i],
        DatabaseHelper.colCompleted: 0,
        DatabaseHelper.colTask: widget.taskDataTasks[i]
      };
      dbHelper.update(row);

      setState(() {
        widget.taskDataComp[i] = 0;
      });
    }
  }

  void delete(int index) {
    dbHelper.delete(widget.taskDataIds[index]);
    setState(() {
      widget.taskDataTasks;
    });
  }
}
