import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pet_feeder_v2/screens/landing_screen.dart';
import 'package:pet_feeder_v2/screens/parent_screen.dart';
import 'package:pet_feeder_v2/styles.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import 'global_providers.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _showNotification(notifID, title, body) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'your_channel_id', // Replace with a unique identifier
    'Your Channel Name', // Replace with a user-friendly name
    channelDescription:
        'Your Channel Description', // Replace with a description
    importance: Importance.max,
    priority: Priority.high,
    showWhen: false,
    enableVibration: true,
  );
  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );

  await flutterLocalNotificationsPlugin.show(
    notifID, // Notification ID
    title, // Notification Title
    body, // Notification Body
    platformChannelSpecifics,
  );
}

void main() async {
  
  var providers = await GlobalProviders.register();
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();


  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()!
      .requestNotificationsPermission();
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()!
      .requestExactAlarmsPermission();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top],
  );
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark));
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) =>
              // runZonedGuarded(() {
              runApp(MyApp(
                providers: providers,
              ))
          // }, FirebaseCrashlytics.instance.recordError)
          );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.providers});
  final List<dynamic> providers;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var hasLoggedin = false;
  
  void cekSession() async {
    final pref = await SharedPreferences.getInstance();

    setState(() {
      hasLoggedin = pref.getBool(HAS_LOGGED_IN) ?? false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cekSession();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [...widget.providers],
      child: ResponsiveSizer(
        builder: (context,orientation,type) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: hasLoggedin ? const ParentScreen() : const LandingScreen() ,
            builder: EasyLoading.init(),
          );
        }
      ),
    );
  }
}