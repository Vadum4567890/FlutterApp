// ignore_for_file: always_put_required_named_parameters_first, avoid_bool_literals_in_conditional_expressions

class Device {
  int id;
  final String name;
  final String status;
  final double value;
  final String unit;
  final String location;
  final bool isActive;
  final int batteryLevel;
  final double minThreshold;
  final double maxThreshold;

  Device({
    this.id = 0,
    required this.name,
    required this.status,
    required this.value,
    required this.unit,
    required this.location,
    required this.isActive,
    required this.batteryLevel,
    required this.minThreshold,
    required this.maxThreshold,
  });

  static Device fromMap(Map<String, dynamic> map) {
    return Device(
      id: map['id'] is int ? map['id'] as int : 0,
      name: map['name']?.toString() ?? '',
      status: map['status']?.toString() ?? '',
      value: (map['value'] as num?)?.toDouble() ?? 0.0,
      unit: map['unit']?.toString() ?? '',
      location: map['location']?.toString() ?? '',
      isActive: map['isActive'] is bool ? map['isActive'] as bool : false,
      batteryLevel: map['batteryLevel'] is int ? map['batteryLevel'] as int : 0,
      minThreshold: (map['minThreshold'] as num?)?.toDouble() ?? 0.0,
      maxThreshold: (map['maxThreshold'] as num?)?.toDouble() ?? 100.0,
    );
  }

  Map<String, dynamic> toMap() {
    final map = {
      'name': name,
      'status': status,
      'value': value,
      'unit': unit,
      'location': location,
      'isActive': isActive,
      'batteryLevel': batteryLevel,
      'minThreshold': minThreshold,
      'maxThreshold': maxThreshold,
    };
    if (id != 0) {
      map['id'] = id;
    }
    return map;
  }

  @override
  String toString() {
    return 'Device{id: $id, name: $name, value: $value $unit, status: $status, location: $location}';
  }
}
