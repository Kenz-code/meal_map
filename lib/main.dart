import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:meal_map/core/services/settings_service.dart';
import 'package:meal_map/routes/app_router.dart';
import 'app/app.dart';
import 'package:provider/provider.dart';
import 'app/app_provider.dart';
import 'core/services/shared_prefs_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // file with open ai key
  await dotenv.load(fileName: "main.env");

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await SharedPrefsService.init();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((value) => runApp(DevicePreview(
    enabled: false,
    builder: (context) => MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(SharedPrefsService.instance),
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
    ),
  )));

  // runApp(MultiProvider(
  //   providers: [
  //     ChangeNotifierProvider(
  //       create: (_) => ThemeProvider(),
  //     ),
  //     ChangeNotifierProvider(
  //       create: (_) => AppStateNotifier(),
  //     ),
  //   ],
  //   child: Consumer<AppStateNotifier>(
  //     builder: (context, appState, _) {
  //       final router = createRouter(appState);
  //
  //       return MyApp(
  //         router: router,
  //       );
  //     },
  //   ),
  // ));
}
