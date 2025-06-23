import 'package:flutter/material.dart';
import 'package:meal_map/routes/app_router.dart';
import 'app/app.dart';
import 'package:provider/provider.dart';
import 'app/app_provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => AppStateNotifier(),
      ),
    ],
    child: Consumer<AppStateNotifier>(
      builder: (context, appState, _) {
        final router = createRouter(appState);

        return MyApp(router: router,);
      },
    ),
  ));
}


