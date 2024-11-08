import 'package:flutter/material.dart';
import 'header_widget.dart'; // Import the header widget

class TimerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HeaderWidget(), // Use the HeaderWidget at the top
          const Expanded(
            child: Center(
              child: Text(
                '00:00:00',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your play functionality here
          print('Play Button Pressed');
        },
        child: Icon(Icons.play_arrow, size: 32), // "Play" icon
        backgroundColor: Colors.green,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
