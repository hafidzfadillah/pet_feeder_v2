import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService {
  MqttServerClient? _client;

  Future<void> connect() async {
    _client = MqttServerClient.withPort('broker.hivemq.com', 'catfeeder', 1883);
    _client?.logging(on: true);

    final connMessage =
        MqttConnectMessage().withClientIdentifier('catfeeder').keepAliveFor(60);

    _client?.connectionMessage = connMessage;

    try {
      await _client?.connect();
    } catch (e) {
      print('Exception: $e');
      _client?.disconnect();
    }
  }

  void sendMessage(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);

    _client?.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
  }

  void disconnect() {
    _client?.disconnect();
  }
}