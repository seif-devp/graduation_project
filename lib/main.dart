import 'package:flutter/material.dart';
import 'package:graduation_project/core/services/app_initializer.dart';
import 'package:graduation_project/work.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize all app services
  await AppInitializer().initialize();

  runApp(const Work());
}
