import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pet_feeder_v2/providers/data_provider.dart';
import 'package:pet_feeder_v2/styles.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HistoryDialog extends StatelessWidget {
  const HistoryDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(
          'Feeding History',
          weight: FontWeight.w500,
          size: 20,
        ),
        SizedBox(
          height: 2.h,
        ),
        Expanded(
          child: Consumer<DataProvider>(
            builder: (context, prov, child) {
              if (prov.dateList == null || prov.dateList!.isEmpty) {
                if (prov.onSearch) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return Center(
                  child: OutlineButton(
                      onClick: () {
                        prov.fetchHistory();
                      },
                      label: 'Muat Ulang',
                      color: accentColor),
                );
              }

              return RefreshIndicator(
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: prov.dateList!.length,
                    separatorBuilder: (context, index) => Divider(),
                    itemBuilder: (context, index) => MyText(
                        DateFormat('EEEE, dd MMM yyyy | HH:mm:ss')
                            .format(DateTime.parse(prov.dateList![index]))),
                  ),
                  onRefresh: () async {
                    prov.fetchHistory();
                  });
            },
          ),
        )
      ],
    );
  }
}
