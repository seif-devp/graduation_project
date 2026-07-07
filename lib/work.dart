import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/core/route/route.dart';
import 'package:graduation_project/core/services/app_initializer.dart';
import 'package:graduation_project/core/widgets/global_chat_bot_button.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Work extends StatefulWidget {
  const Work({super.key});

  @override
  State<Work> createState() => _WorkState();
}

class _WorkState extends State<Work> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    // Listen to app lifecycle events
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        // App came back to foreground - restart background token refresh
        AppInitializer().restartBackgroundRefresh();
        print('📱 App resumed - Background token refresh restarted');
        break;
      case AppLifecycleState.paused:
        print('📱 App paused');
        break;
      case AppLifecycleState.detached:
        // App is closing
        AppInitializer().cleanup();
        print('📱 App detached - Cleanup completed');
        break;
      case AppLifecycleState.inactive:
        print('📱 App inactive');
        break;
      case AppLifecycleState.hidden:
        print('📱 App hidden');
        break;
    }
  }

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
          builder: (context, routedChild) {
            return Stack(
              children: [
                if (routedChild != null) routedChild,
                const GlobalChatBotButton(),
              ],
            );
          },
        );
      },
    );
  }
}