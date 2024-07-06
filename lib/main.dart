// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();
  await initNotifications();
  runApp(const MyApp());
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

@pragma('vm:entry-point')
void timerCallback() async {
  await flutterLocalNotificationsPlugin.show(
    0,
    'Timer Finished',
    'Your timer has completed!',
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'timer_channel_id',
        'Timer Notifications',
        importance: Importance.max,
        priority: Priority.high,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Timer App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TimerPage(),
    );
  }
}

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  final TextEditingController _controller = TextEditingController();

  Future<void> requestAlarmPermission() async {
    if (await Permission.scheduleExactAlarm.isDenied) {
      final status = await Permission.scheduleExactAlarm.request();
      if (status.isDenied) {
        // Permission denied, show a dialog or snackbar to inform the user
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Alarm permission is required for the timer to work properly')),
        );
      }
    }
  }

  Future<void> startTimer(int seconds) async {
    // Check and request permission before setting the alarm
    if (await Permission.scheduleExactAlarm.isGranted) {
      const int timerId = 0; // Unique ID for this timer
      final DateTime scheduledTime =
          DateTime.now().add(Duration(seconds: seconds));

      await AndroidAlarmManager.oneShotAt(
        scheduledTime,
        timerId,
        timerCallback,
        exact: true,
        wakeup: true,
        rescheduleOnReboot: true,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Timer set for $seconds seconds')),
      );
    } else {
      // Permission not granted, show a dialog or snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Alarm permission is required to set the timer')),
      );
      // Optionally, you can open app settings for the user to grant permission manually
      // openAppSettings();
    }
  }

  @override
  void initState() {
    super.initState();
    requestAlarmPermission(); // Request permission when the page is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Timer App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter time in seconds',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                int? seconds = int.tryParse(_controller.text);
                if (seconds != null && seconds > 0) {
                  startTimer(seconds);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Please enter a valid number of seconds')),
                  );
                }
              },
              child: const Text('Start Timer'),
            ),
          ],
        ),
      ),
    );
  }
}
