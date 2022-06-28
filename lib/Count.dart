import 'package:flutter/material.dart';

class Count extends StatefulWidget {
  final int count;
  Count({required this.count});

  @override
  State<Count> createState() => _CountState();
}

class _CountState extends State<Count> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        '${widget.count}',
        style: const TextStyle(fontSize: 24),
      ),
    );
  }
}
