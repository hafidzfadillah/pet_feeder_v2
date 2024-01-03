import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pet_feeder_v2/providers/data_provider.dart';
import 'package:pet_feeder_v2/styles.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FragmentHome extends StatefulWidget {
  const FragmentHome({super.key});

  @override
  State<FragmentHome> createState() => _FragmentHomeState();
}

class _FragmentHomeState extends State<FragmentHome> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DataProvider.instance(context).fetchSuhu();
    DataProvider.instance(context).fetchHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          DataProvider.instance(context).fetchSuhu();
          DataProvider.instance(context).fetchHistory();
        },
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 8.h),
          children: [
            Row(
              children: [
                profileImage(3.h, USER_IMG),
                SizedBox(
                  width: 2.h,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MyText('Hello,'),
                    MyText(
                      USER_NAME,
                      size: 20,
                      weight: FontWeight.w500,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 4.h,
            ),
            data(),
            SizedBox(height: 4.h),
            Row(
              children: [
                Icon(
                  Icons.thermostat_outlined,
                  color: accentColor,
                  size: 32,
                ),
                SizedBox(
                  width: 1.h,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MyText(
                      'Average Temperature',
                      size: 16,
                      weight: FontWeight.w500,
                    ),
                    MyText('for the last 5 days')
                  ],
                )
              ],
            ),
            SizedBox(
              height: 1.h,
            ),
            temperatureChart(),
          ],
        ),
      ),
    );
  }

  Widget profileImage(double sizeRadius, String linkImage) => CircleAvatar(
        radius: sizeRadius,
        backgroundColor: Colors.black,
        child: ClipOval(
          child: Image.network(
            linkImage,
            fit: BoxFit.cover,
            width: sizeRadius * 2,
            height: sizeRadius * 2,
          ),
        ),
      );

  Widget data() => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: primaryColor.withOpacity(0.3),
        ),
        padding: EdgeInsets.all(2.h),
        child: Consumer<DataProvider>(
          builder: (context, prov, child) {
            if (prov.lastFeedingTimestamp == null) {
              if (prov.onSearch) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return Center(
                child: OutlineButton(
                    color: Colors.white,
                    label: 'Refresh',
                    onClick: () {
                      prov.fetchLastFeedingTimestamp();
                      prov.fetchSuhu();
                    }),
              );
            }

            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: Row(
                          children: [
                            Icon(
                              Icons.thermostat,
                              color: primaryColorDark,
                            ),
                            SizedBox(
                              width: 1.h,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                MyText(
                                  'Temperature',
                                  size: 12,
                                ),
                                MyText(
                                  '25°C',
                                  weight: FontWeight.w500,
                                  size: 20,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Row(
                          children: [
                            Icon(
                              Icons.pets,
                              color: primaryColorDark,
                            ),
                            SizedBox(
                              width: 1.h,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                MyText(
                                  'Stock',
                                  size: 12,
                                ),
                                MyText(
                                  'IN STOCK',
                                  weight: FontWeight.w500,
                                  size: 20,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 2.h,
                ),
                Container(
                  child: Row(
                    children: [
                      Icon(
                        Icons.history,
                        color: primaryColorDark,
                      ),
                      SizedBox(
                        width: 1.h,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          MyText(
                            'Last Feeding Time',
                            size: 12,
                          ),
                          MyText(
                            DateFormat('EEE, dd MMM yyyy | HH:mm:ss').format(
                                DateTime.parse(prov.lastFeedingTimestamp!)),
                            weight: FontWeight.w600,
                          ),
                          MyText(
                            tsDistance(prov.lastFeedingTimestamp ?? '0'),
                            isItalic: true,
                            size: 12,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      );

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

  Widget temperatureChart() => Column(
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: primaryColor.withOpacity(0.3),
            ),
            child: Consumer<DataProvider>(builder: (context, prov, _) {
              if (prov.tempData == null) {
                if (prov.onSearch) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return Center(
                  child: OutlineButton(
                      color: accentColor,
                      label: 'Muat Ulang',
                      onClick: () {
                        prov.fetchSuhu();
                      }),
                );
              }

              return LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  minX: 0,
                  maxX: prov.tempData!.length - 1.0,
                  minY: 0,
                  maxY: 50,
                  lineBarsData: [
                    LineChartBarData(
                      isCurved: false,
                      colors: [Color(0xFF406338)],
                      dotData: FlDotData(show: true),
                      barWidth: 5,
                      belowBarData: BarAreaData(
                        show: true,
                        colors: [Color(0xFF406338)]
                            .map((color) => color.withOpacity(0.3))
                            .toList(),
                      ),
                      spots: List.generate(
                        prov.tempData!.length,
                        (index) => FlSpot(
                            index.toDouble(),
                            double.parse(
                                prov.tempData![index]["rata_rata_suhu"])),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
          Consumer<DataProvider>(
            builder: (context, prov, child) {
              if (prov.tempData == null) {
                return Container();
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  for (var data in prov.tempData!)
                    MyText('${data["rata_rata_suhu"]} °C',
                        color: primaryColorDark, weight: FontWeight.w500),
                ],
              );
            },
          )
        ],
      );
}
