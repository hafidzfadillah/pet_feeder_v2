import 'package:pet_feeder_v2/providers/data_provider.dart';
import 'package:provider/provider.dart';

class GlobalProviders {
  static Future register() async => [
    ChangeNotifierProvider(create: (context) => DataProvider())
  ];
}
