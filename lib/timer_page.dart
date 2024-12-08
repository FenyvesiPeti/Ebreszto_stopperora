import 'package:flutter/material.dart';
import 'dart:async';
import 'header_widget.dart';

class TimerPage extends StatefulWidget {
  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  late Timer _timer;
  int _milliseconds = 0;
  bool _isRunning = false;
  List<String> _flaggedTimes = [];

  void _startTimer() {
    if (!_isRunning) {
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          _milliseconds += 1000;
        });
      });
      setState(() {
        _isRunning = true;
      });
    }
  }

  void _stopTimer() {
    if (_isRunning) {
      _timer.cancel();
      setState(() {
        _isRunning = false;
      });
    }
  }

  void _resetTimer() {
    setState(() {
      _milliseconds = 0;
      _flaggedTimes.clear();
    });
  }

  void _flagTime() {
    setState(() {
      _flaggedTimes.add(_formatTime(_milliseconds));
    });
  }

  String _formatTime(int milliseconds) {
    int seconds = milliseconds ~/ 1000;
    int minutes = seconds ~/ 60;
    int hours = minutes ~/ 60;
    String formattedTime = 
      '${hours.toString().padLeft(2, '0')}:'
      '${(minutes % 60).toString().padLeft(2, '0')}:'
      '${(seconds % 60).toString().padLeft(2, '0')}';
    return formattedTime;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HeaderWidget(),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _formatTime(_milliseconds),
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  ..._flaggedTimes.map((time) => Text(
                    time,
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  )).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Offstage(
            offstage: _isRunning,
            child: FloatingActionButton(
              onPressed: _startTimer,
              child: Icon(Icons.play_arrow, size: 32),
              backgroundColor: Colors.green,
            ),
          ),
          Offstage(
            offstage: !_isRunning,
            child: FloatingActionButton(
              onPressed: _stopTimer,
              child: Icon(Icons.pause, size: 32),
              backgroundColor: Colors.red,
            ),
          ),
          const SizedBox(width: 10),
          Offstage(
            offstage: !_isRunning,
            child: FloatingActionButton(
              onPressed: _flagTime,
              child: Icon(Icons.flag, size: 32),
              backgroundColor: Colors.blue,
            ),
          ),
          Offstage(
            offstage: _isRunning,
            child: FloatingActionButton(
              onPressed: _resetTimer,
              child: Icon(Icons.stop, size: 32),
              backgroundColor: Colors.pink,
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}