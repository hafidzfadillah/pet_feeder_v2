import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pet_feeder_v2/providers/data_provider.dart';
import 'package:pet_feeder_v2/screens/history_dialog.dart';
import 'package:pet_feeder_v2/styles.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../services/mqtt_service.dart';

class FragmentFeed extends StatefulWidget {
  const FragmentFeed({super.key});

  @override
  State<FragmentFeed> createState() => _FragmentFeedState();
}

class _FragmentFeedState extends State<FragmentFeed> {
  final MqttService mqttService = MqttService();

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
                      child: prov.lastFeedingTimestamp != null && !prov.onSearch
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
}
