import 'package:flutter/material.dart';
import 'header_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alarm Clock',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AlarmClockPage(),
    );
  }
}

class AlarmClockPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
  body: Column(
    children: [
      HeaderWidget(),
      const Expanded(
        child: Center(
          child: Text(
            'No Alarms Set',
            style: TextStyle(fontSize: 24, color: Colors.grey),
          ),
        ),
      ),
    ],
  ),
  floatingActionButton: FloatingActionButton(
    onPressed: () {
      // Add your alarm-setting functionality here
      print('Add Alarm Button Pressed');
    },
    child: Icon(Icons.add, size: 32), // "+" icon in the center
    backgroundColor: Colors.blue,
  ),
  floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
);
  }
}
