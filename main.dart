import 'package:flutter/material.dart';
import 'dart:async';
import 'alarm.dart';
import 'universal_header.dart'; // Import the new file

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TimerPage(),
    );
  }
}

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  late Timer _timer;
  int _start = 0;
  bool _isRunning = false;

  void startTimer() {
    setState(() {
      _isRunning = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _start++;
      });
    });
  }

  void stopTimer() {
    _timer.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  void resetTimer() {
    _timer.cancel();
    setState(() {
      _start = 0;
      _isRunning = false;
    });
  }

  String get timerText {
    final minutes = (_start ~/ 60).toString().padLeft(2, '0');
    final seconds = (_start % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const UniversalHeader(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              timerText,
              style: const TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 20),
            if (!_isRunning)
              ElevatedButton(
                onPressed: startTimer,
                child: const Text('Start Timer'),
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: stopTimer,
                    child: const Text('Stop Timer'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: resetTimer,
                    child: const Text('Reset Timer'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}