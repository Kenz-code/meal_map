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



  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _auth = AuthService();

  String get _currentUserId => _auth.currentUser?.uid ?? '';

  DocumentReference get _userDoc =>
      _firestore.collection('users').doc(_currentUserId);

  CollectionReference get _userDevicesCollection =>
      _userDoc.collection('devices');

  Future<void> _addDevice(DeviceModel device) async {
    if (_currentUserId.isEmpty) {
      throw Exception('User is not authenticated');
    }
    final doc = await _userDoc.get();
    if (!doc.exists) {
      throw Exception('User document does not exist');
    }

    await _userDevicesCollection
        .doc(device.id)
        .set(
      device.toMap(),
      SetOptions(merge: true)
    );
  }

  Future<void> registerCurrentDevice() async {
    final currentDevice = await _createCurrentDeviceModel();
    await _addDevice(currentDevice);
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

  Future<void> unregisterCurrentDevice() async {
    final deviceID = await getDeviceId();
    await _deleteDevice(deviceID);
  }

  Future<DeviceModel> _createCurrentDeviceModel() async  {
    final deviceInfo = DeviceInfoPlugin();
    late DeviceModel device;
    final deviceID = await getDeviceId();

    if (kIsWeb) {
      BaseDeviceInfo baseDeviceInfo = await deviceInfo.deviceInfo;

      device = DeviceModel(
        id: deviceID,
        platform: "Web",
        model: "${baseDeviceInfo.data['manufacturer'].capitalizeFirst} ${baseDeviceInfo.data['model']}",
        name: baseDeviceInfo.data['name'],
        appVersion: AppVersionService.instance.version,
        createdAt: DateTime.now(),
        lastActive: DateTime.now(),
      );
    } else if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      device = DeviceModel(
        id: deviceID,
        platform: "Android",
        model: "${androidInfo.manufacturer.capitalizeFirst()} ${androidInfo.model}",
        name: androidInfo.name,
        appVersion: AppVersionService.instance.version,
        createdAt: DateTime.now(),
        lastActive: DateTime.now(),
      );
    } else if (Platform.isIOS) {
      throw UnimplementedError("Unimplemented platform: IOS");
    }


    return device;
  }

  Future<void> updateCurrentDeviceLastActive() async {
    await _userDevicesCollection
        .doc(await getDeviceId())
        .update({
    'lastActive': FieldValue.serverTimestamp(),
    });
  }

  Future<String> getDeviceId() async {
    final existing =
    SharedPrefsService.instance.getString('deviceID');

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

  Future<List<DeviceModel>> getDevices() async {
    if (_currentUserId.isEmpty) {
      throw Exception('User is not authenticated');
    }

    final snapshot = await _userDevicesCollection.get();

    return snapshot.docs.map((doc) {
      return DeviceModel.fromMap(
        doc.data() as Map<String, dynamic>,
      );
    }).toList();
  }

  Stream<List<DeviceModel>> watchDevices() {
    if (_currentUserId.isEmpty) {
      throw Exception('User is not authenticated');
    }

    return _userDevicesCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return DeviceModel.fromMap(
          doc.data() as Map<String, dynamic>,
        );
      }).toList();
    });
  }
}