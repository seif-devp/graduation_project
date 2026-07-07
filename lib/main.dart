import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graduation_project/core/services/app_initializer.dart';
import 'package:graduation_project/work.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  // Initialize all app services
  await AppInitializer().initialize();

  runApp(const Work());
}
