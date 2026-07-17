import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:meal_map/core/extensions/string_casing_extension.dart';
import 'package:meal_map/core/models/device_model.dart';
import 'package:meal_map/core/services/app_version_service.dart';
import 'package:meal_map/core/services/firebase_auth_service.dart';
import 'package:meal_map/core/services/shared_prefs_service.dart';
import 'package:uuid/uuid.dart';

class DeviceService {
  DeviceService._();

  static final instance = DeviceService._();

  static const _deviceNameKey = 'deviceName';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _auth = AuthService();

  String get _currentUserId => _auth.currentUser?.uid ?? '';

  DocumentReference get _userDoc =>
      _firestore.collection('users').doc(_currentUserId);

  CollectionReference get _userDevicesCollection =>
      _userDoc.collection('devices');

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  Future<void> registerCurrentDevice() async {
    final currentDevice = await _createCurrentDeviceModel();
    await _addDevice(currentDevice);
  }

  Future<void> unregisterCurrentDevice() async {
    final deviceId = await getDeviceId();
    await _deleteDevice(deviceId);
  }

  Future<void> updateCurrentDeviceLastActive() async {
    await _userDevicesCollection.doc(await getDeviceId()).update({
      'lastActive': FieldValue.serverTimestamp(),
    });
  }

  Future<List<DeviceModel>> getDevices() async {
    if (_currentUserId.isEmpty) {
      throw Exception('User is not authenticated');
    }

    final snapshot = await _userDevicesCollection.get();

    return snapshot.docs
        .map(
          (doc) => DeviceModel.fromMap(
        doc.data() as Map<String, dynamic>,
      ),
    )
        .toList();
  }

  Stream<List<DeviceModel>> watchDevices() {
    if (_currentUserId.isEmpty) {
      throw Exception('User is not authenticated');
    }

    return _userDevicesCollection.snapshots().map(
          (snapshot) => snapshot.docs
          .map(
            (doc) => DeviceModel.fromMap(
          doc.data() as Map<String, dynamic>,
        ),
      )
          .toList(),
    );
  }

  Future<DeviceModel> getCurrentDevice() async {
    final id = await getDeviceId();

    final snapshot = await _userDevicesCollection.doc(id).get();

    return DeviceModel.fromMap(
      snapshot.data() as Map<String, dynamic>,
    );
  }

  Future<void> renameCurrentDevice(String newName) async {
    final trimmed = newName.trim();

    if (trimmed.isEmpty) {
      throw Exception('Device name cannot be empty.');
    }

    await SharedPrefsService.instance.setString(
      _deviceNameKey,
      trimmed,
    );

    await _userDevicesCollection.doc(await getDeviceId()).update({
      'name': trimmed,
    });
  }

  // ---------------------------------------------------------------------------
  // Device Name
  // ---------------------------------------------------------------------------

  Future<String> getCurrentDeviceName() async {
    final existing = SharedPrefsService.instance.getString(_deviceNameKey);

    if (existing != null && existing.isNotEmpty) {
      return existing;
    }

    final technicalName = await getTechnicalDeviceName();

    await SharedPrefsService.instance.setString(
      _deviceNameKey,
      technicalName,
    );

    return technicalName;
  }

  Future<String> getTechnicalDeviceName() async {
    final deviceInfo = DeviceInfoPlugin();

    if (kIsWeb) {
      final info = await deviceInfo.deviceInfo;
      return info.data['name'] ?? 'Web Browser';
    }

    if (Platform.isAndroid) {
      final info = await deviceInfo.androidInfo;
      return info.name;
    }

    throw UnimplementedError('Unimplemented platform.');
  }

  // ---------------------------------------------------------------------------
  // Device ID
  // ---------------------------------------------------------------------------

  Future<String> getDeviceId() async {
    final existing = SharedPrefsService.instance.getString('deviceID');

    if (existing != null) {
      return existing;
    }

    final id = const Uuid().v4();

    await SharedPrefsService.instance.setString(
      'deviceID',
      id,
    );

    return id;
  }

  // ---------------------------------------------------------------------------
  // Private Helpers
  // ---------------------------------------------------------------------------

  Future<void> _addDevice(DeviceModel device) async {
    if (_currentUserId.isEmpty) {
      throw Exception('User is not authenticated');
    }

    final doc = await _userDoc.get();

    if (!doc.exists) {
      throw Exception('User document does not exist');
    }

    await _userDevicesCollection.doc(device.id).set(
      device.toMap(),
      SetOptions(merge: true),
    );
  }

  Future<void> _deleteDevice(String id) async {
    if (_currentUserId.isEmpty) {
      throw Exception('User is not authenticated');
    }

    final doc = await _userDoc.get();

    if (!doc.exists) {
      throw Exception('User document does not exist');
    }

    await _userDevicesCollection.doc(id).delete();
  }

  Future<DeviceModel> _createCurrentDeviceModel() async {
    final deviceInfo = DeviceInfoPlugin();
    final deviceId = await getDeviceId();

    if (kIsWeb) {
      final info = await deviceInfo.webBrowserInfo;
      return DeviceModel(
        id: deviceId,
        platform: 'Web',
        model: '${info.browserName.name}',
        name: await getCurrentDeviceName(),
        appVersion: AppVersionService.instance.version,
        createdAt: DateTime.now(),
        lastActive: DateTime.now(),
      );
    }

    if (Platform.isAndroid) {
      final info = await deviceInfo.androidInfo;

      return DeviceModel(
        id: deviceId,
        platform: 'Android',
        model: '${info.manufacturer.capitalizeFirst()} ${info.model}',
        name: await getCurrentDeviceName(),
        appVersion: AppVersionService.instance.version,
        createdAt: DateTime.now(),
        lastActive: DateTime.now(),
      );
    }

    throw UnimplementedError('Unimplemented platform.');
  }
}