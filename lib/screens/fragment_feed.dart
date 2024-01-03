import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone_updated_gradle/flutter_native_timezone.dart';
import 'package:intl/intl.dart';
import 'package:pet_feeder_v2/providers/data_provider.dart';
import 'package:pet_feeder_v2/screens/history_dialog.dart';
import 'package:pet_feeder_v2/styles.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:timezone/timezone.dart' as tz;

import '../services/mqtt_service.dart';

class FragmentFeed extends StatefulWidget {
  const FragmentFeed({super.key});

  @override
  State<FragmentFeed> createState() => _FragmentFeedState();
}

class _FragmentFeedState extends State<FragmentFeed> {
  final MqttService mqttService = MqttService();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DataProvider.instance(context).fetchLastFeedingTimestamp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyText(
                  'Tap here to feed!',
                  size: 24,
                  weight: FontWeight.w500,
                ),
                SizedBox(
                  height: 4.h,
                ),
                InkWell(
                  onTap: () async {
                    // Tambahkan logika koneksi dan pengiriman pesan MQTT
                    await mqttService.connect();
                    mqttService.sendMessage('control_servo_iot_d2', '1');
                    mqttService.disconnect();
                  },
                  child: CircleAvatar(
                    radius: 128,
                    backgroundColor: Color(0xFF6BA35D),
                    child: Image.asset(
                      'assets/images/buttonfeed.png',
                      width: 90.w,
                      height: 90.w,
                    ),
                  ),
                ),
                SizedBox(
                  height: 4.h,
                ),
                OutlineButton(
                    width: 40.w,
                    onClick: () async {
                      await _showReminderDialog();
                    },
                    label: 'Set Reminder',
                    color: primaryColor)
              ],
            )),
            Container(
              width: double.infinity,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 2.h, vertical: 4.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: primaryColor.withOpacity(0.3),
                ),
                child: Consumer<DataProvider>(builder: (context, prov, _) {
                  return InkWell(
                    onTap: () {
                      prov.fetchHistory();
                      showModalSheet(context, 65.h, HistoryDialog());
                    },
                    child: Padding(
                      padding: EdgeInsets.all(2.h),
                      child: prov.lastFeedingTimestamp != null
                          ? Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      MyText('Last feeding time'),
                                      MyText(
                                        formatTime(
                                            prov.lastFeedingTimestamp ?? '0'),
                                        weight: FontWeight.w500,
                                        size: 18,
                                      ),
                                      MyText(
                                        tsDistance(
                                            prov.lastFeedingTimestamp ?? '0'),
                                        isItalic: true,
                                      )
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.format_list_bulleted,
                                  color: primaryColorDark,
                                )
                              ],
                            )
                          : MyText('Fetching data last time feeding..'),
                    ),
                  );
                }),
              ),
            )
          ],
        ),
      ),
    );
  }

  String formatTime(String ts) {
    return ts == '0'
        ? ts
        : DateFormat('dd MMM yyyy, HH:mm:ss').format(DateTime.parse(ts));
  }

  String tsDistance(String ts) {
    if (ts == '0') {
      return ts;
    }
    var now = DateTime.now();
    var lastfeed = DateTime.parse(ts);
    var diff = now.difference(lastfeed);
    var result = [];

    int days = diff.inDays;
    int hours = diff.inHours % 24;
    int minutes = diff.inMinutes % 60;
    int seconds = diff.inSeconds % 60;

    if (days != 0) {
      result.add('${days} hari');
    }

    if (hours != 0) {
      result.add('${hours} jam');
    }

    if (minutes != 0) {
      result.add('${minutes} menit');
    }

    // if (seconds != 0) {
    //   result.add('${seconds} detik');
    // }

    return result.join(', ') + ' yang lalu';
  }

  Future<void> _showReminderDialog() async {
    TextEditingController _messageController =
        TextEditingController(text: 'Feeding Time!');
    DateTime _selectedDateTime = DateTime.now();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestExactAlarmsPermission()
        .then((value) {
      if (value == null || !value) {
        return;
      }
    });

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Feeding reminder'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _messageController,
                enabled: false,
              ),
              SizedBox(height: 16),
              ListTile(
                title: Text('Choose datetime'),
                subtitle: Text(
                  DateFormat.yMMMMd().add_jm().format(_selectedDateTime),
                ),
                trailing: Icon(Icons.keyboard_arrow_down),
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _selectedDateTime,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    print(pickedDate);
                    final pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
                    );
                    print(pickedTime);
                    if (pickedTime != null) {
                      setState(() {
                        _selectedDateTime = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                      });

                      print(_selectedDateTime);
                    }
                    print(_selectedDateTime);
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Confirm'),
              onPressed: () async {
                if (_messageController.text.isNotEmpty) {
                  EasyLoading.show(status: 'Set reminder..');
                  await _scheduleNotification(
                    _selectedDateTime,
                    _messageController.text,
                  );
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _scheduleNotification(DateTime scheduledTime, String msg) async {
    // messageController.text =
    //     "Set reminder: ${scheduledTime.day} ${scheduledTime.month} ${scheduledTime.year}, ${scheduledTime.hour}:${scheduledTime.minute}";
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        icon: "@mipmap/ic_launcher");

    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    var timeZone = await FlutterNativeTimezone.getLocalTimezone();
    var location = tz.getLocation(timeZone);
    var tzDateTime = tz.TZDateTime.from(scheduledTime, location);

    await flutterLocalNotificationsPlugin.zonedSchedule(
        0, 'Reminder', msg, tzDateTime, platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
    
    EasyLoading.showSuccess('Set Reminder Done');
  }
}
