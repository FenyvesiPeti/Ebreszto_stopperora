/*
Nem működik semmi itt mentenénk el az ébresztőket

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Alarm {
  TimeOfDay time;
  String label;
  bool isEnabled;

  Alarm(this.time, this.label, {this.isEnabled = true});

  Map<String, dynamic> toJson() => {
        'hour': time.hour,
        'minute': time.minute,
        'label': label,
        'isEnabled': isEnabled,
      };

  factory Alarm.fromJson(Map<String, dynamic> json) {
    return Alarm(
      TimeOfDay(hour: json['hour'], minute: json['minute']),
      json['label'],
      isEnabled: json['isEnabled'],
    );
  }
}

class AlarmStorage {
  static Future<void> saveAlarms(List<Alarm> alarms) async {
    final prefs = await SharedPreferences.getInstance();
    final String alarmsString = jsonEncode(alarms.map((alarm) => alarm.toJson()).toList());
    await prefs.setString('alarms', alarmsString);
  }

  static Future<List<Alarm>> loadAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    final String? alarmsString = prefs.getString('alarms');
    if (alarmsString != null) {
      final List<dynamic> alarmsJson = jsonDecode(alarmsString);
      return alarmsJson.map((json) => Alarm.fromJson(json)).toList();
    }
    return [];
  }
}*/