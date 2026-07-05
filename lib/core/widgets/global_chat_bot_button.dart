import 'package:flutter/material.dart';
import 'package:graduation_project/features/chat_bot/chat_bot.dart';
import 'package:graduation_project/core/const/colors.dart';
import 'package:graduation_project/core/route/route.dart';

/// زرار الـ Chat Bot العائم، بيتحط على مستوى الـ MaterialApp.router نفسه
/// (فوق كل الشاشات) فبيفضل ظاهر أينما تنقلت في التطبيق، ماعدا شاشات
/// الدخول/التسجيل المذكورة في _hiddenPaths.
class GlobalChatBotButton extends StatelessWidget {
  const GlobalChatBotButton({super.key});

  // الشاشات اللي الزرار مش المفروض يظهر فيها خالص
  static const List<String> _hiddenPaths = [
    '/',
    '/login',
    '/sign_up',
    '/signup',
    '/startup',
  ];

  String _currentLocation() {
    // بنقرأ الـ route الحالي مباشرة من كائن الـ router نفسه، من غير ما
    // نعتمد على context (لأن الزرار مش جوه شجرة الـ Router).
    return router.routerDelegate.currentConfiguration.uri.toString();
  }

  @override
  Widget build(BuildContext context) {
    // ListenableBuilder بيخلي الزرار يظهر/يختفي فورًا لما الـ route يتغير،
    // من غير ما نحتاج نعمل setState يدوي.
    return ListenableBuilder(
      listenable: router.routerDelegate,
      builder: (context, _) {
        final location = _currentLocation();
        if (_hiddenPaths.contains(location)) {
          return const SizedBox.shrink();
        }

        return Positioned(
          bottom: 90,
          right: 16,
          child: GestureDetector(
            onTap: () {
              rootNavigatorKey.currentState?.push(
                MaterialPageRoute(
                    builder: (context) => const CareerCoachScreen()),
              );
            },
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: primaryColor,
                  width: 2.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipOval(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(
                    'assets/icons/chatbot.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.smart_toy, color: primaryColor),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}