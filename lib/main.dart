import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // 1. أضف الـ Import ده
import 'package:graduation_project/core/route/route.dart';

void main() {
  runApp(DevicePreview(enabled: false, builder: (context) => const MyApp()));

  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 814),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          locale: DevicePreview.locale(context),
          debugShowCheckedModeBanner: false,
          routerConfig: router,
        );
      },
    );
  }
}
