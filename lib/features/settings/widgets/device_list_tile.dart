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

  String timeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return '$minutes minute${minutes == 1 ? '' : 's'} ago';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours hour${hours == 1 ? '' : 's'} ago';
    } else if (difference.inDays < 30) {
      final days = difference.inDays;
      return '$days day${days == 1 ? '' : 's'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months == 1 ? '' : 's'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years year${years == 1 ? '' : 's'} ago';
    }
  }

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
            '${isCurrent ? 'Active now' : 'Last active ${timeAgo(device.lastActive)}'}',
      ),
      isThreeLine: true,
    );
  }
}