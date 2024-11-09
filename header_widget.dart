import 'package:flutter/material.dart';
import 'main.dart';
import 'alarm_page.dart';

//A header widget, ami a felső navigációs sávot tartalmazza.
//Felépítése: 1 sor, benne 2 oszlop. Az első oszlopban az ébresztő ikonja és szövege, a másodikban a stopperóra ikonja és szövege.
//Ha a felhasználó rákattint az egyik ikonra, akkor az adott oldalra navigál.

//TODO: Alapjároton fehér/szüke színű az ikon + szöveg de amikor az adott oldalon vagyunk akkor legyen kék színű az ikon + szöveg

class HeaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 1.0), 
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
              SizedBox(height: 4), 
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
                MaterialPageRoute(builder: (context) => TimerPage()),
              );
            },
          child: const Column(
            children: [
              Icon(Icons.watch_later, size: 32, color: Colors.blue),
              SizedBox(height: 4), 
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
