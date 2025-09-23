import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meal_map/core/theme/theme.dart';
import 'package:meal_map/features/splash/screens/main.dart';
import 'package:provider/provider.dart';
import 'app_provider.dart';

class MyApp extends StatelessWidget {
  GoRouter router;

  MyApp({super.key, required this.router});


  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp.router(
      routerConfig: router,
      title: 'MealMap',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeProvider.currentMode,
      builder: (context, child) {
        final initialized = context.watch<AppStateNotifier>().initialized;
        if (!initialized) return const SplashScreen();
        return child!;
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(
                title: const Text("Toggle Dark Mode"),
                value: themeProvider.isDark,
                onChanged: (_) => themeProvider.toggleTheme(),
              ),

              SizedBox(height: 8,),

              ElevatedButton(onPressed: () {Provider.of<AppStateNotifier>(context, listen: false).logout();}, child: Text("Logout")),

              SizedBox(height: 8,),

              TextButton(onPressed: () {}, child: Text("Button")),

              SizedBox(height: 8,),

              OutlinedButton(onPressed: () {}, child: Text("Button")),

              SizedBox(height: 8,),

              FilledButton(onPressed: () {}, child: Text("Button")),

              SizedBox(height: 8,),

              Text(GoRouter.of(context).state.path!)
            ],
          ),
        ),
      ),
    );
  }
}
