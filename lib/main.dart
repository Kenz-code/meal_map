import 'package:flutter/material.dart';
import 'package:meal_map/routes/app_router.dart';
import 'app/app.dart';
import 'package:provider/provider.dart';
import 'app/app_provider.dart';
import 'core/services/shared_prefs_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await SharedPrefsService.init();

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

        return MyApp(
          router: router,
        );
      },
    ),
  ));
}
