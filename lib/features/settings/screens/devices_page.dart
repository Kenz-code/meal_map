import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:meal_map/core/models/device_model.dart';
import 'package:meal_map/core/services/device_service.dart';
import 'package:meal_map/features/settings/widgets/device_list_tile.dart';

class DevicesPage extends StatefulWidget {
  const DevicesPage({super.key});

  @override
  State<DevicesPage> createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {
  late final Future<String> _currentDeviceId;

  @override
  void initState() {
    super.initState();
    _currentDeviceId = DeviceService.instance.getDeviceId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Connected Devices".text(),
      ),
      body: FutureBuilder<String>(
        future: _currentDeviceId,
        builder: (context, idSnapshot) {
          if (!idSnapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final currentDeviceId = idSnapshot.data!;

          return StreamBuilder<List<DeviceModel>>(
            stream: DeviceService.instance.watchDevices(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final devices = snapshot.data!;

              return ListView.builder(
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  return DeviceListTile(
                    device: devices[index],
                    currentDeviceId: currentDeviceId,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}