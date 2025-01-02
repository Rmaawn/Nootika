import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_list/main.dart';

// ignore: must_be_immutable
class AlarmNotificationScreen extends StatefulWidget {
  AlarmSettings alarmSettings;
  AlarmNotificationScreen({super.key, required this.alarmSettings});

  @override
  State<AlarmNotificationScreen> createState() =>
      _AlarmNotificationScreenState();
}

class _AlarmNotificationScreenState extends State<AlarmNotificationScreen> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              primaryColor,
              primaryContainer
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Alram is ringing......."),
            Text(widget.alarmSettings.notificationSettings.title),
            Text(widget.alarmSettings.notificationSettings.body),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      //skip alarm for next time
                      final now = DateTime.now();
                      Alarm.set(
                        alarmSettings: widget.alarmSettings.copyWith(
                          dateTime: DateTime(
                            now.year,
                            now.month,
                            now.day,
                            now.hour,
                            now.minute,
                          ).add(const Duration(minutes: 1)),
                        ),
                      ).then((_) => Navigator.pop(context));
                    },
                    child: const Text("Snooze")),
                ElevatedButton(
                    onPressed: () {
                      //stop alarm
                      Alarm.stop(widget.alarmSettings.id)
                          .then((_) => Navigator.pop(context));
                    },
                    child: const Text("Stop")),
              ],
            )
          ],
        ),
      ),
    );
  }
}