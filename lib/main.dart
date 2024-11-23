import 'dart:async';
import 'package:flutter/material.dart';
//import 'package:audioplayers/audioplayers.dart';
import 'package:just_audio/just_audio.dart';

//Jelenlegi hiba: Amikor oldalt váltunk vagy kilépünk a programból akkor az ébresztők elvesznek.
//Próbáltam SharedPreferences-el, Fájlba mentéssel/olvasással, adatbázissal egyik se működött.

import 'header_widget.dart';
import 'timer_page.dart';
import 'CED_alarm/create_alarm.dart';
import 'CED_alarm/edit_alarm.dart';
import 'CED_alarm/delete_alarm.dart';

//showalarmsDialog metódust, checkAlarm metódust, és maga az oldal megjelenítést nem tettem át másik fájlba mert 
// úgy nem működött... Szóval ezeket itt hagytam.

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

//Osztály a hang lejátszására
class AlarmSoundManager {
  final AudioPlayer _audioPlayer = AudioPlayer();

  /// Metódus a hang lejátszására
  Future<void> playRingtone() async {
    try {
      // Helyi fájl beállítása
      await _audioPlayer.setAsset('assets/ringtone.mp3');
      await _audioPlayer.play();
    } catch (e) {
      print("Hiba a hang lejátszása közben: $e");
    }
  }

  /// Metódus a hang leállítására
  Future<void> stopRingtone() async {
    try {
      await _audioPlayer.stop();
    } catch (e) {
      print("Hiba a hang leállítása közben: $e");
    }
  }

  /// Felszabadítja az erőforrásokat
  void dispose() {
    _audioPlayer.dispose();
  }
}
final alarmSoundManager = AlarmSoundManager();

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
    alarmSoundManager.playRingtone();
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
              alarmSoundManager.stopRingtone();
              Navigator.of(context).pop();  
            },
          ),
          //Renderben gomb ami kidob a modal ablakból
          TextButton(
            child: const Text('Rendben'),
            onPressed: () {
              alarmSoundManager.stopRingtone();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

  //Metódus az új ébresztő hozzáadására
  void _addNewAlarm() {
   addNewAlarm(context, alarms, setState);
  }

  //Metódus az ébresztő(k) szerkesztésére
  void _editAlarm(Alarm alarm) {
    editAlarm(context, alarm, setState);
  }

  //MEtódus az ébresztők törlésére
  void _deleteAlarm(Alarm alarm) {
    deleteAlarm(alarm, alarms, setState);
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
      
      const SizedBox(height: 10),
      FloatingActionButton(
        onPressed: () {
          // Itt hívjuk meg a _showAlarmDialog-ot egy teszt Alarm objektummal
          final testAlarm = Alarm(TimeOfDay.now(), "Test Alarm");
          _showAlarmDialog(testAlarm);
        },
        child: Icon(Icons.alarm, size: 32),
        backgroundColor: Colors.red,
      ),
    
      
    ],
  ),
      //Ezért vannak a lebegő gombo(k) az oldal alján és középen 
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}