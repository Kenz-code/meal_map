import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:meal_map/core/services/app_version_service.dart';
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

  await dotenv.load(fileName: "main.env");

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await SharedPrefsService.init();
  await AppVersionService.instance.init();

  final appStateNotifier = AppStateNotifier();
  final router = createRouter(appStateNotifier);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((value) => runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(SharedPrefsService.instance),
        ),
        ChangeNotifierProvider.value(
          value: appStateNotifier,
        ),
      ],
      child: MyApp(
        router: router,
      ),
    ),
  ));
}

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
// }
