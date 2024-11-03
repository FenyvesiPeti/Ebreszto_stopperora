import 'package:flutter/material.dart';
import 'main.dart';
import 'alarm.dart';

class UniversalHeader extends StatelessWidget implements PreferredSizeWidget {
  const UniversalHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFDDDDDD), // #ddd color
            width: 1.0,
            style: BorderStyle.solid,
          ),
        ),
      ),
      child: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.timer),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const TimerPage()),
                );
              },
            ),
            const SizedBox(width: 20), // Add some spacing between icons
            IconButton(
              icon: const Icon(Icons.alarm),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const AlarmPage()),
                );
              },
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}