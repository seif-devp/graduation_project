import 'package:go_router/go_router.dart';
import 'package:graduation_project/features/Home/screens/start_up_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => StartUpScreen()),
    GoRoute(path: '/routes', builder: (context, state) => StartUpScreen()),
  ],
);
