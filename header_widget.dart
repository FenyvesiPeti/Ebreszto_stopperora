import 'package:flutter/material.dart';
import 'main.dart';
import 'alarm_page.dart';

class HeaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 1.0), // Bottom border
        ),
      ),
      child: Padding(padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AlarmClockPage()),
              );
            },
          child: const Column(
            children: [
              Icon(Icons.alarm, size: 32, color: Colors.blue),
              SizedBox(height: 4), // Spacing between icon and text
              Text(
                'Ébresztő',
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ],
          ),
       ),
       GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TimerPage()), // Replace with your StopwatchPage
              );
            },
          child: const Column(
            children: [
              Icon(Icons.watch_later, size: 32, color: Colors.blue),
              SizedBox(height: 4), // Spacing between icon and text
              Text(
                'Stopperóra',
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ],
          ),
        ),
        ],
      ),
      ),
    );
  }
}
