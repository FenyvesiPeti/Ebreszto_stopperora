/*import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'main.dart';  // Az Alarm osztályt importálni kell, ha másik fájlban van


//Ez a kóddal fogjuk majd elmenti az ébresző adatokat JSON fájlban. Még NEM működik, csak a kód van itt.
//Most jelenleg az van hogyha kilépnk a programból vagy átmegyünk a stopperóra oldalra akkor minden adat elveszik :)
class AlarmStorage {
  // Alarms betöltése SharedPreferences-ből
  static Future<List<Alarm>> loadAlarms() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? alarmList = prefs.getStringList('alarms');
    
    if (alarmList != null) {
      // Ha van mentett lista, akkor visszatérítjük az Alarm objektumokat
      return alarmList.map((alarmStr) {
        final alarmData = jsonDecode(alarmStr);
        return Alarm(
          TimeOfDay(
            hour: alarmData['time']['hour'],
            minute: alarmData['time']['minute'],
          ),
          alarmData['label'],
          isEnabled: alarmData['isEnabled'],
        );
      }).toList();
    }
    return []; // Ha nincs mentett adat, üres listát adunk vissza
  }

  // Alarms mentése SharedPreferences-be
  static Future<void> saveAlarms(List<Alarm> alarms) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    List<String> alarmList = alarms.map((alarm) {
      // Alarm objektumokat JSON formátumba alakítjuk, hogy tárolható legyen
      return jsonEncode({
        'time': {'hour': alarm.time.hour, 'minute': alarm.time.minute},
        'label': alarm.label,
        'isEnabled': alarm.isEnabled,
      });
    }).toList();
    
    await prefs.setStringList('alarms', alarmList);  // Mentjük az adatokat
  }
}*/
