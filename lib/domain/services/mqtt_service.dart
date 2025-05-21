// ignore_for_file: inference_failure_on_function_return_type

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService {
  late final MqttServerClient _client;

  /// [server] — адреса MQTT-брокера
  /// [clientIdentifier] — ідентифікатор клієнта
  /// [port] — порт для підключення (за замовчуванням 1883)
  MqttService(
    String server,
    String clientIdentifier, {
    this.port = 8081,
  }) {
    _client = MqttServerClient(server, clientIdentifier)..port = port;
  }

  final int port;

  Future<void> connect() async {
    try {
      await _client.connect();
    } catch (e) {
      throw Exception('Failed to connect to MQTT: $e');
    }
  }

  void subscribe(String topic, Function(String) onMessage) {
    _client.subscribe(topic, MqttQos.atMostOnce);
    _client.updates
        ?.listen((List<MqttReceivedMessage<MqttMessage?>>? messages) {
      for (var message in messages!) {
        final payload = message.payload as MqttPublishMessage;
        final messageContent =
            MqttPublishPayload.bytesToStringAsString(payload.payload.message);
        onMessage(messageContent);
      }
    });
  }

  void disconnect() {
    _client.disconnect();
  }
}
