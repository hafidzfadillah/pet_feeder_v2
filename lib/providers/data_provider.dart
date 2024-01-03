import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DataProvider extends ChangeNotifier {
  List<String>? _dateList;
  List<String>? get dateList => _dateList;

  List<Map<String, dynamic>>? _tempData;
  List<Map<String, dynamic>>? get tempData => _tempData;

  String? _lastFeedingTimestamp;
  String? get lastFeedingTimestamp => _lastFeedingTimestamp;

  bool isDisposed = false;

  /// Event handling
  bool _onSearch = false;
  bool get onSearch => _onSearch;

  static DataProvider instance(BuildContext context) =>
      Provider.of(context, listen: false);

  Future<void> fetchHistory() async {
    await Future.delayed(Duration(milliseconds: 100));
    setOnSearch(true);
    final response = await http.get(Uri.parse(
        'https://kelompokd2iot.000webhostapp.com/petfeeder/api/getlast10days.php'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      _dateList = data.map((item) => item['ts'].toString()).toList();
    } else {
      _dateList = [];
      EasyLoading.showError('Failed to load history');
    }
    setOnSearch(false);
  }

  Future<void> fetchSuhu() async {
    await Future.delayed(Duration(milliseconds: 100));
    setOnSearch(true);
    final response = await http.get(Uri.parse(
        'https://kelompokd2iot.000webhostapp.com/petfeeder/api/getrataratasuhu.php'));

    if (response.statusCode == 200) {
      _tempData = List<Map<String, dynamic>>.from(json.decode(response.body));

      // Fetch last feeding timestamp
      await fetchLastFeedingTimestamp();
    } else {
      _tempData = [];
      EasyLoading.showError('Failed to load temperature');
    }
    setOnSearch(false);
  }

  Future<void> fetchLastFeedingTimestamp() async {
    await Future.delayed(Duration(milliseconds: 100));
    setOnSearch(true);
    final response = await http.get(Uri.parse(
        'https://kelompokd2iot.000webhostapp.com/petfeeder/api/getlastday.php'));

    if (response.statusCode == 200) {
      print(response.body);
      final List<Map<String, dynamic>> lastDayData =
          List<Map<String, dynamic>>.from(json.decode(response.body));

      if (lastDayData.isNotEmpty) {
        _lastFeedingTimestamp = lastDayData[0]['ts'];
      }
    } else {
      _lastFeedingTimestamp = '0';
      EasyLoading.showError('Failed to fetch last feeding timestamp');
    }
    setOnSearch(false);
  }

  /// Set event search
  void setOnSearch(bool value) {
    _onSearch = value;
    notifyListeners();
  }

  @override
  void notifyListeners() {
    if (!isDisposed) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
  }
}
