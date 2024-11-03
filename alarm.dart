import 'package:flutter/material.dart';
import 'universal_header.dart'; // Import the new file

class AlarmPage extends StatelessWidget {
  const AlarmPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const UniversalHeader(),
      body: const Center(
        child: Text(
          'Alarm Clock Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              // Add function here
            },
            child: const Text('Set Alarm'),
          ),
        ),
      ),
    );
  }
}