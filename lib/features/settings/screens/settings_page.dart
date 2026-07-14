import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meal_map/app/app_provider.dart';
import 'package:meal_map/core/extensions/context_theme_extensions.dart';
import 'package:meal_map/core/services/settings_service.dart';
import 'package:meal_map/core/widgets/confirm_dialog.dart';
import 'package:meal_map/features/auth/widgets/pair_device_qr_dialog.dart';
import 'package:meal_map/features/settings/widgets/pulsing_tile.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Widget _sectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        top: 24,
        bottom: 8,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        color: context.colorScheme.primary,
        child: Text(title, style: context.textTheme.titleLarge?.copyWith(
            color: context.colorScheme.onPrimary)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = SettingsService();
    final themeProvider = Provider.of<ThemeProvider>(context);

    final highlight = context.watch<AppStateNotifier>().highlightQrLogin;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: ListView(
        children: [

          _sectionHeader(context, "Appearance"),

          SwitchListTile(
            title: "Dark mode".text(),
            thumbIcon: WidgetStateProperty<Icon?>.fromMap(
              <WidgetStatesConstraint, Icon>{
                WidgetState.selected: Icons.dark_mode_rounded.icon(),
                WidgetState.disabled: Icons.light_mode_rounded.icon()
              },
            ),
            secondary: Icons.brightness_4_rounded.icon(),
            value: themeProvider.isDark,
            onChanged: (newValue) {
              themeProvider.toggleTheme();
            },
          ),

          _sectionHeader(context, "Devices"),

          ListTile(
            title: "Connected Devices".text(),
            leading: Icons.phone_iphone_rounded.icon(),
            trailing: Icons.arrow_forward_ios_rounded.icon(),
            onTap: () {
              context.push("/settings/devices");
            },
          ),

          PulsingTile(
            enabled: highlight,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                boxShadow: highlight
                    ? [
                  BoxShadow(
                    blurRadius: 10,
                    spreadRadius: -4,
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withOpacity(.15),
                  )
                ]
                    : [],
              ),
              child: ListTile(
                title: "Connect new device with QR code".text(),
                leading: Icons.qr_code_2_rounded.icon(),
                onTap: () {
                  context.read<AppStateNotifier>().clearQrHighlight();

                  showDialog(
                    context: context,
                    builder: (_) => PairDeviceDialog(),
                  );
                },
              ),
            ),
          ),

          ListTile(
            title: "Edit current device name".text(),
            leading: Icons.edit_rounded.icon(),
            trailing: Icons.arrow_forward_ios_rounded.icon(),
            onTap: () {
              context.push("/settings/editDeviceName");
            },
          ),

          _sectionHeader(context, "Account"),

          ListTile(
            title: "Sign out".text(),
            leading: Icons.logout_rounded.icon(),
            onTap: () {
              Provider.of<AppStateNotifier>(context, listen: false).logout();
            },
          ),

          ListTile(
            title: "Delete account"
                .text()
                .styled(color: context.colorScheme.error),
            leading: Icons.delete_forever_rounded.icon(
              color: context.colorScheme.error,
            ),
            onTap: () async {
              await showDialog<bool>(
                context: context,
                builder: (context) => ConfirmDialog(
                  title: 'Delete Account'.text(),
                  content: "Are you sure you want to delete your account? THIS ACTION IS PERMANENT".text(),
                  confirmLabel: "Delete",
                  isConfirmError: true,
                  onConfirm: () async {
                    Provider.of<AppStateNotifier>(
                      context,
                      listen: false,
                    ).deleteAccount();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}