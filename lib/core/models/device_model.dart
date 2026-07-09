import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meal_map/core/services/shared_prefs_service.dart';

class DeviceModel {
  final String name;
  final String platform;
  final String model;
  final String appVersion;
  final DateTime lastActive;
  final DateTime createdAt;

  DeviceModel({
    required this.name,
    required this.platform,
    required this.model,
    required this.appVersion,
    required this.lastActive,
    required this.createdAt,
  });

  factory DeviceModel.fromMap(Map<String, dynamic> map) {
    return DeviceModel(
      name: map['name'] as String,
      platform: map['platform'] as String,
      model: map['model'] as String,
      appVersion: map['appVersion'] as String,
      lastActive: (map['lastActive'] as Timestamp).toDate(),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'platform': platform,
      'model': model,
      'appVersion': appVersion,
      'lastActive': Timestamp.fromDate(lastActive),
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  String id() {
    return SharedPrefsService.instance.getString("deviceID") ?? "";
  }
}