import '../main.dart';

//Kitörli az ébresztőt az ébresztők listájából
void deleteAlarm(Alarm alarm, List<Alarm> alarms, Function setStateCallback) {
  setStateCallback(() {
    alarms.remove(alarm);
  });
}