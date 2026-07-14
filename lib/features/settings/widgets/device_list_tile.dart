import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meal_map/core/extensions/context_theme_extensions.dart';
import 'package:meal_map/core/models/device_model.dart';

class DeviceListTile extends StatelessWidget {
  final DeviceModel device;
  final String currentDeviceId;
  final VoidCallback? onTap;

  const DeviceListTile({
    super.key,
    required this.device,
    required this.currentDeviceId,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isCurrent = device.id == currentDeviceId;

    IconData icon;

    switch (device.platform.toLowerCase()) {
      case 'android':
        icon = Icons.phone_android_rounded;
        break;
      case 'web':
        icon = Icons.language_rounded;
        break;
      case 'ios':
        icon = Icons.phone_iphone_rounded;
        break;
      default:
        icon = Icons.devices_rounded;
    }

    return ListTile(
      onTap: onTap,
      leading: Icon(icon),
      title: Row(
        children: [
          Expanded(
            child: Text(
              device.name,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (isCurrent)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                'This device',
                style: Theme.of(context).textTheme.labelSmall!.copyWith(color: context.colorScheme.onPrimaryContainer),
              ),
            ),
        ],
      ),
      subtitle: Text(
        '${device.model}\n'
            'Last active ${DateFormat.yMMMd().add_jm().format(device.lastActive)}',
      ),
      isThreeLine: true,
    );
  }
}