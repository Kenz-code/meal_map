import 'package:flutter/material.dart';
import 'package:meal_map/core/theme/theme.dart';
import 'package:provider/provider.dart';
import 'app_provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'MealMap',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeProvider.currentMode,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
          child: SwitchListTile(
            title: const Text("Toggle Dark Mode"),
            value: themeProvider.isDark,
            onChanged: (_) => themeProvider.toggleTheme(),
          ),
        ),
      ),
    );
  }
}
