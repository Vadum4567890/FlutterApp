import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_project/domain/services/mqtt_service.dart';
import 'package:my_project/models/device.dart';

class DevicesScreen extends StatefulWidget {
  const DevicesScreen({super.key});

  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  final List<Device> _devices = [];
  late MqttService _mqttService;
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    _mqttService = MqttService(
      'test.mosquitto.org',
      'flutter_client',
      port: 8081,
    );
    _connectAndSubscribe();
  }

  Future<void> _connectAndSubscribe() async {
    try {
      await _mqttService.connect();
      if (!mounted) return;
      setState(() {
        isConnected = true;
      });
      debugPrint('Connected to MQTT broker');

      // Підписка на топік
      _mqttService.subscribe('devices/data', (message) {
        try {
          final data = jsonDecode(message);
          if (data is List) {
            final List<Device> newDevices = data
                .map((e) => Device.fromMap(e as Map<String, dynamic>))
                .toList();
            if (!mounted) return;
            setState(() {
              _devices
                ..clear()
                ..addAll(newDevices);
            });
          }
        } catch (e) {
          debugPrint('Error parsing message: $e');
        }
      });
    } catch (e) {
      debugPrint('Failed to connect to MQTT: $e');
    }
  }

  Widget _buildDeviceCard(Device device) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        title: Text('${device.name} (${device.status})'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Value: ${device.value} ${device.unit}'),
            Text('Battery: ${device.batteryLevel}%'),
            Text('Active: ${device.isActive ? "Yes" : "No"}'),
            Text('Location: ${device.location}'),
            Text('Thresholds: ${device.minThreshold} - ${device.maxThreshold}'),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Devices')),
      body: isConnected
          ? _devices.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: _devices.length,
                  itemBuilder: (context, index) =>
                      _buildDeviceCard(_devices[index]),
                )
          : const Center(child: Text('Not connected to MQTT')),
    );
  }
}
