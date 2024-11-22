import 'package:flutter/material.dart';
import '../main.dart';
//Időválasztó párbeszédablak, ahol a felhasználó kiválaszthatja az ébresztő idejét
  //"await" kulcszó megvárja ameddig a felhasználó választ egy időpontot, ha null értékkel tér vissza akkor a felhasználó nem választott időpontot
  Future<void> addNewAlarm(BuildContext context, List<Alarm> alarms, Function setStateCallback) async {
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
                setStateCallback(() {
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