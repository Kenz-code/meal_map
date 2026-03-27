import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:meal_map/app/app_provider.dart';
import 'package:meal_map/core/extensions/context_theme_extensions.dart';
import 'package:meal_map/core/services/settings_service.dart';
import 'package:meal_map/core/widgets/confirm_dialog.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = SettingsService();
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: "Dark mode".text(),
            thumbIcon: WidgetStateProperty<Icon?>.fromMap(<WidgetStatesConstraint, Icon>{
              WidgetState.selected: Icons.dark_mode_rounded.icon(),
              WidgetState.disabled: Icons.light_mode_rounded.icon()
            }),
            secondary: Icons.brightness_4_rounded.icon(),
            value: themeProvider.isDark,
            onChanged: (newValue) {
              themeProvider.toggleTheme();
            },
          ),

          ListTile(
            title: "Sign out".text(),
            leading: Icons.logout_rounded.icon(),
            onTap: () {
              Provider.of<AppStateNotifier>(context, listen: false).logout();
            },
          ),

          ListTile(
            title: "Delete account".text().styled(color: context.colorScheme.error),
            leading: Icons.delete_forever_rounded.icon(color: context.colorScheme.error),
            onTap: () async {
              await showDialog<bool>(
                context: context,
                builder: (context) => ConfirmDialog(
                  title: 'Delete Account'.text(),
                  content: "Are you sure you want to delete your account? THIS ACTION IS PERMANENT".text(),
                  confirmLabel: "Delete",
                  isConfirmError: true,
                  onConfirm: () async {Provider.of<AppStateNotifier>(context, listen: false).deleteAccount();},
                ),
              );
            },
          ),
        ],
      )
    );
  }
}
