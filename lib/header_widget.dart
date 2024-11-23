import 'package:flutter/material.dart';
import 'main.dart';
import 'timer_page.dart';

//A header widget, ami a felső navigációs sávot tartalmazza.
//Felépítése: 1 sor, benne 2 oszlop. Az első oszlopban az ébresztő ikonja és szövege, a másodikban a stopperóra ikonja és szövege.
//Ha a felhasználó rákattint az egyik ikonra, akkor az adott oldalra navigál.

//TODO: Alapjároton fehér/szüke színű az ikon + szöveg de amikor az adott oldalon vagyunk akkor legyen kék színű az ikon + szöveg
//Írtam ehez egy kevés kódot de nem működik... Valamiért a szín csak egy ideig változik meg utána visszáll szürkére

class HeaderWidget extends StatefulWidget {
  @override
  _HeaderWidgetState createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  Color _alarmIconColor = Colors.blue;
  Color _alarmTextColor = Colors.blue;
  Color _timerIconColor = Colors.blue;
  Color _timerTextColor = Colors.blue;
  String _selectedType = '';

  void _changeColor(String type) {
    setState(() {
      if (type == 'alarm') {
        _selectedType = 'alarm';
        _alarmIconColor = Colors.blue;
        _alarmTextColor = Colors.blue;
        _timerIconColor = Colors.grey;
        _timerTextColor = Colors.grey;
      } else if (type == 'timer') {
        _selectedType = 'timer';
        _timerIconColor = Colors.blue;
        _timerTextColor = Colors.blue;
        _alarmIconColor = Colors.grey;
        _alarmTextColor = Colors.grey;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 1.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                _changeColor('alarm');
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AlarmClockPage()),
                );
              },
              child: Column(
                children: [
                  Icon(Icons.alarm, size: 32, color: _alarmIconColor),
                  SizedBox(height: 4),
                  Text(
                    'Ébresztő',
                    style: TextStyle(fontSize: 16, color: _alarmTextColor),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                _changeColor('timer');
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => TimerPage()),
                );
              },
              child: Column(
                children: [
                  Icon(Icons.watch_later, size: 32, color: _timerIconColor),
                  SizedBox(height: 4),
                  Text(
                    'Stopperóra',
                    style: TextStyle(fontSize: 16, color: _timerTextColor),
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