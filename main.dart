import 'package:flutter/material.dart';
import 'header_widget.dart';
import 'alarm_page.dart';

void main() {
  runApp(MyApp());
}

//Beállítjuk az alkalmazásunkat a MaterialApp widgettel, majd a főoldalát az AlarmClockPage-re állítjuk.
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

//Itt az ébresztő törzse. Ha nincs még felvéve ébresztő, akkor egy szürke szöveget jelenítünk meg, hogy nincs még felvéve ébresztő. 
//Ha van felvéve ébresztő, akkor azokat jelenítjük meg.
class AlarmClockPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
  body: Column(
    children: [
      //Hazsnáljuk a header widgetet
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
  //Egy lebegő gomb amivel hozzátudunk adni egy új ébresztő időpontot.
  floatingActionButton: FloatingActionButton(
    onPressed: () {
      // Majd ide kell írni a kódot
      print('Add Alarm Button Pressed');
    },
    // "+" ikon a gomb közepére
    child: Icon(Icons.add, size: 32), 
    backgroundColor: Colors.blue,
  ),
  floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
);
  }
}
