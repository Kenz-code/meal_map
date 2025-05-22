import 'package:flutter/material.dart';
import 'app/app.dart';
import 'package:provider/provider.dart';
import 'app/app_provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (_) => ThemeProvider(),
    child: const MyApp(),
  ));
}


