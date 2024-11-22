import 'package:flutter/material.dart';
import '../main.dart';

//Ébreztő szerkesztése
void editAlarm(BuildContext context, Alarm alarm, Function setStateCallback) {
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
                  setStateCallback(() {
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
              setStateCallback(() {
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