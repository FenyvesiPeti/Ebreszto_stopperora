import 'dart:async';
import 'package:flutter/material.dart';

//Ez a adatok mentére kell majd de még nem működik
//import 'package:shared_preferences/shared_preferences.dart';
//import 'dart:convert';

//Jelenlegi hiba: Amikor oldalt váltunk vagy kilépünk a programból akkor az ébresztők elvesznek.
//Ezt meglehetne oldani azzal, hogy az ébresztőket elmentjük egy JSON fájlba és betöltjük a program indulásakor.
//Viszont amikor ezt megpróbáltam akkor teljesen rossz lett minden és újra kellett telepítenem az eumulátort.


import 'header_widget.dart';
import 'alarm_page.dart';
import 'alarm_storage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ébresztő oldal',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AlarmClockPage(),
    );
  }
}

//Alarm osztály ami az ébresztők adatait tárolja
class Alarm {
  TimeOfDay time;
  String label;
  bool isEnabled;

  Alarm(this.time, this.label, {this.isEnabled = true});
}

class AlarmClockPage extends StatefulWidget {
  const AlarmClockPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AlarmClockPageState createState() => _AlarmClockPageState();
}

//Az ébresztő oldal törzse, itt lehet új ébresztőket hozzáadni, szerkeszteni és törölni
class _AlarmClockPageState extends State<AlarmClockPage> {
  //Lista az ébresztők tárolására
  List<Alarm> alarms = [];
  //Az időzítő változója "?-> lehet, hogy nem lesz értéke"
  Timer? _timer;

  //Megnézi hogy az ébresztők közül valamelyiknek az ideje megegyezik-e a jelenlegi idővel
  @override
  void initState() {
    super.initState();
    _startAlarmChecker();
  }

  //Percenként ellenőrzi az ébresztőket
  void _startAlarmChecker() {
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _checkAlarms();
    });
  }

  //Metódus ami nézi a jelenlegi időt és az ébresztők idejét
  void _checkAlarms() {
    final now = TimeOfDay.now();
     //Teszteléshez kiírjuk a debug konzolra a jelenlegi időt (emultároban néha random az óra)
    print("Jelenlegi idő: ${now.format(context)}");
    for (var alarm in alarms) {
      //Ha az ébresztő be van kapcsolva és az ideje megegyezik a jelenlegivel
      if (alarm.isEnabled && alarm.time.hour == now.hour && alarm.time.minute == now.minute) {
        //Megghívjuk a _showAlarmDialog metódust az adott ébresztő adataival
        _showAlarmDialog(alarm);
        break;  // Egyszerre csak egy ébresztőt jelenít meg
      }
    }
  }

  //Az ébresztó ablak megjelenítése (modal) 
  void _showAlarmDialog(Alarm alarm) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Ébresztő!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(alarm.label),
            const SizedBox(height: 10),
            Text('Jelenlegi idő: ${alarm.time.format(context)}'),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('10 perc szundi'),
            onPressed: () {
              // Új ébresztő létrehozása az eredetihez képest +10 perccel
              int newMinute = (alarm.time.minute + 10) % 60;
              int newHour = alarm.time.hour + (alarm.time.minute + 10) ~/ 60;

              setState(() {
                // Új ébresztő hozzáadása a listához
                alarms.add(Alarm(
                  TimeOfDay(hour: newHour % 24, minute: newMinute),
                  '${alarm.label} (Szundi)',
                ));
              });
              // Bezárjuk a modal ablakot
              Navigator.of(context).pop();  
            },
          ),
          //Renderben gomb ami kidob a modal ablakból
          TextButton(
            child: const Text('Rendben'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

  //Aszinkron metódus ami a risztás hozzáadását végzi
  void _addNewAlarm() async {
    //Időválasztó párbeszédablak, ahol a felhasználó kiválaszthatja az ébresztő idejét
    //"await" kulcszó megvárja ameddig a felhasználó választ egy időpontot, ha null értékkel tér vissza akkor a felhasználó nem választott időpontot
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    //Ha nem null akkor:
    if (pickedTime != null) {
      TextEditingController labelController = TextEditingController();

      //Címke megadás + mégse és mentés gombok
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Adjon meg egy címkét'),
            content: TextField(
              controller: labelController,
              decoration: const InputDecoration(labelText: 'Címke'),
            ),
            actions: [
              TextButton(
                child: const Text('Mégse'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Mentés'),
                onPressed: () {
                  setState(() {
                    alarms.add(Alarm(pickedTime, labelController.text));
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  //Metódus az ébresztő(k) szerkesztésére
  void _editAlarm(Alarm alarm) {
    TextEditingController labelController = TextEditingController(text: alarm.label);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          //Oszlop elrendezés
          title: const Text('Ébresztő szerkesztése'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: labelController,
                decoration: const InputDecoration(labelText: 'Címke'),
              ),
              const SizedBox(height: 20),
              // Időválasztó gomb
              TextButton(
                onPressed: () async {
                  final TimeOfDay? newTime = await showTimePicker(
                    context: context,
                    initialTime: alarm.time,
                  );
                  // Ha a felhasználó kiválasztott egy új időpontot, akkor frissítjük az ébresztő idejét
                  if (newTime != null) {
                    setState(() {
                      alarm.time = newTime;
                    });
                  }
                },
                child: const Text("Időpont szerkesztése"),
              ),
            ],
          ),
          //Megse és mentés gombok
          actions: [
            TextButton(
              child: const Text('Mégse'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Mentés'),
              onPressed: () {
                setState(() {
                  alarm.label = labelController.text;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //MEtódus az ébresztők törlésére
  void _deleteAlarm(Alarm alarm) {
    //A setState metódus segítségével frissítjük az ébresztők listáját
    setState(() {
      //Az ébresztő törlése a listából
      alarms.remove(alarm);
    });
  }

  @override
  void dispose() {
    // Az időzítő leállítása, ha az oldal elhagyása megtörténik (ezt majd törölni kell ha az alarm_storage.dart működik)
    //A "?" miatt csak akkor fut le ha a _timer nem null
    _timer?.cancel(); 
    //Ez feltakarítja a lezárt időzítőt, így nem lesz memory leak stb
    super.dispose();
  }

  //Az oldal megjelenítés törzse (oszlop elrendezés)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          //Használjuk a header widgetet
          HeaderWidget(),
          //Expanded miatt kitölti az egész rendelkezésre álló helyet
          Expanded(
            //Ha nincs ébresztő akkor egy szöveg jelenik meg, ha van akkor az ébresztők listája (ez olyan mint php-ban a ? : operátor)
            child: alarms.isEmpty
                ? const Center(
                    child: Text(
                      'Nincs ébresztő beállítva',
                      style: TextStyle(fontSize: 24, color: Colors.grey),
                    ),
                  )
                  //Listview miatt lesz görgethető az oszlop (lista)
                : ListView.builder(
                    //Itt nézi meg hogy hány ébresztő van
                    itemCount: alarms.length,
                    //És aszerint jelenti meg az ébresztőket
                    itemBuilder: (context, index) {
                      final alarm = alarms[index];
                      //Itt hívja meg vizuálisan az ébresztőket
                      return ListTile(
                        //Baloldalt: az ébresztő ideje és címkéje
                        title: Text(
                          '${alarm.time.format(context)} - ${alarm.label}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          //Jobboldalt: kapcsoló és "több" (edit) gomb
                          children: [
                            Switch(
                              //ALapjáraton a kapcsoló bevan kapcsolva
                              value: alarm.isEnabled,
                              onChanged: (bool value) {
                                setState(() {
                                  alarm.isEnabled = value;
                                });
                              },
                            ),
                            //(edit) gomb, amivel szerkeszteni vagy törölni lehet az adott ébresztőt
                            PopupMenuButton<String>(
                              onSelected: (String choice) {
                                //meghívjujuk a megfelelő metódusokat
                                if (choice == 'Edit') {
                                  _editAlarm(alarm);
                                } else if (choice == 'Delete') {
                                  _deleteAlarm(alarm);
                                }
                              },
                              itemBuilder: (BuildContext context) {
                                return [
                                  const PopupMenuItem<String>(
                                    value: 'Edit',
                                    child: Text('Szerkesztés'),
                                  ),
                                  const PopupMenuItem<String>(
                                    value: 'Delete',
                                    child: Text('Törlés'),
                                  ),
                                ];
                              },
                              //A gomb ikonja
                              icon: const Icon(Icons.more_vert),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
  //Lebegő gomb az oldal alján
  //A "+"gombbal új ébresztőt lehet hozzáadni
  floatingActionButton: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      FloatingActionButton(
        onPressed: _addNewAlarm,
        child: Icon(Icons.add, size: 32),
        backgroundColor: Colors.blue,
      ),

      //TESZT gomb, amivel tesztelhető az ébresztő ablak
      /*
      const SizedBox(height: 10),
      FloatingActionButton(
        onPressed: () {
          // Itt hívjuk meg a _showAlarmDialog-ot egy teszt Alarm objektummal
          final testAlarm = Alarm(TimeOfDay.now(), "Test Alarm");
          _showAlarmDialog(testAlarm);
        },
        child: Icon(Icons.alarm, size: 32),
        backgroundColor: Colors.red,
      ),*/
    
      
    ],
  ),
      //Ezért vannak a lebegő gombo(k) az oldal alján és középen 
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}