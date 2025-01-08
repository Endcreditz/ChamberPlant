import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MQTTManager {
  static final MQTTManager _instance = MQTTManager._internal();
  factory MQTTManager() => _instance;

  final String broker = 'd9de16130942443db19b815cf1b9dffa.s1.eu.hivemq.cloud';
  final int port = 8883;
  final String username = 'kritsakorn';
  final String password = '4Bb089602';

  late MqttServerClient client;

  // Define the default topic
  final String topic = 'esp32/control';

  MQTTManager._internal() {
    client = MqttServerClient(broker, 'flutter_client');
    client.port = port;
    client.logging(on: true);
    client.keepAlivePeriod = 20;
    client.secure = true;
    client.autoReconnect = true;
    client.setProtocolV311();
    client.onConnected = _onConnected;
    client.onDisconnected = _onDisconnected;
    client.onAutoReconnect = _onAutoReconnect;
  }

  Future<void> connect() async {
    final connMessage = MqttConnectMessage()
        .withClientIdentifier('flutter_client')
        .withWillTopic('willtopic') // Will topic
        .withWillMessage('waiting') // Message when unexpectedly disconnected
        .startClean()
        .authenticateAs(username, password);

    client.connectionMessage = connMessage;

    try {
      print('Connecting to MQTT Broker...');
      await client.connect();
      if (client.connectionStatus!.state != MqttConnectionState.connected) {
        throw Exception(
            'Failed to connect. Status: ${client.connectionStatus!.state}');
      }
      print('Connected to MQTT Broker');
    } catch (e) {
      print('MQTT connection error: $e');
      rethrow;
    }
  }

  void disconnect() {
    print('Disconnecting from MQTT Broker...');
    client.disconnect();
  }

  void publish(String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
    print('Published message to $topic: $message');
  }

  // New sendMessage method for ease of use
  void sendMessage(String message) {
    publish(message); // Call publish internally
    print('Message sent to $topic: $message');
  }

  void subscribe() {
    print('Subscribing to $topic');
    client.subscribe(topic, MqttQos.atLeastOnce);
  }

  void unsubscribe() {
    print('Unsubscribing from $topic');
    client.unsubscribe(topic);
  }

  // Callbacks
  void _onConnected() {
    print('Connected successfully to MQTT Broker');
    sendMessage('Hello from App');
  }

  void _onDisconnected() {
    print('Disconnected from MQTT Broker');
  }

  void _onAutoReconnect() {
    print('Attempting to reconnect to MQTT Broker...');
  }
}
