import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:meal_map/core/extensions/string_casing_extension.dart';
import 'package:meal_map/core/models/device_model.dart';
import 'package:meal_map/core/services/app_version_service.dart';
import 'package:meal_map/core/services/firebase_auth_service.dart';
import 'package:meal_map/core/services/shared_prefs_service.dart';
import 'dart:io' show Platform;

class UserFirestoreManagerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _auth = AuthService();

  String get _currentUserId => _auth.currentUser?.uid ?? '';

  DocumentReference get _userDoc =>
      _firestore.collection('users').doc(_currentUserId);

  CollectionReference get _userDevicesCollection =>
      _firestore.collection('users').doc(_currentUserId).collection('devices');

  /// Ensures the user document exists, creates it if not.
  Future<void> ensureUserDocumentExists() async {
    if (_currentUserId.isEmpty) {
      throw Exception('User is not authenticated');
    }
    final doc = await _userDoc.get();
    if (!doc.exists) {
      await _userDoc.set({'createdAt': FieldValue.serverTimestamp()});
    }
  }

  Future<void> createUserDocument(String householdName) async {
    if (_currentUserId.isEmpty) {
      throw Exception('User is not authenticated');
    }
    final doc = await _userDoc.get();
    if (!doc.exists) {
      await _userDoc.set({'createdAt': FieldValue.serverTimestamp(), 'householdName': householdName});

      SharedPrefsService.instance.setString("deviceID", DateTime.now().millisecondsSinceEpoch.toString());
    }
  }

  Future<void> setHouseholdName(String householdName) async {
    if (_currentUserId.isEmpty) {
      throw Exception('User is not authenticated');
    }
    final doc = await _userDoc.get();
    if (!doc.exists) {
      throw Exception('User document does not exist');
    }

    await _userDoc.set({'householdName': householdName});
  }

  Future<void> addDevice(DeviceModel device) async {
    if (_currentUserId.isEmpty) {
      throw Exception('User is not authenticated');
    }
    final doc = await _userDoc.get();
    if (!doc.exists) {
      throw Exception('User document does not exist');
    }

    await _userDevicesCollection
        .doc(device.id())
        .set(device.toMap());
  }

  Future<void> deleteDevice(DeviceModel device) async {
    if (_currentUserId.isEmpty) {
      throw Exception('User is not authenticated');
    }
    final doc = await _userDoc.get();
    if (!doc.exists) {
      throw Exception('User document does not exist');
    }

    await _userDevicesCollection.doc(device.id()).delete();
  }

  Future<DeviceModel?> createCurrentDevice() async  {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    DeviceModel? device;

    if (kIsWeb) {
      BaseDeviceInfo baseDeviceInfo = await deviceInfo.deviceInfo;

      device = DeviceModel(
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
        platform: "Android",
        model: "${androidInfo.manufacturer.capitalizeFirst} ${androidInfo.model}",
        name: androidInfo.name,
        appVersion: AppVersionService.instance.version,
        createdAt: DateTime.now(),
        lastActive: DateTime.now(),
      );
    }


    return device;
  }

  void printLong(String text) {
    const chunkSize = 800;
    for (var i = 0; i < text.length; i += chunkSize) {
      final end = (i + chunkSize < text.length)
          ? i + chunkSize
          : text.length;
      print(text.substring(i, end));
    }
  }
}
