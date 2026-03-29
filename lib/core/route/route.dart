import 'package:go_router/go_router.dart';
import 'package:graduation_project/features/Auth/presentation/Screens/sign_in_screen.dart';
import 'package:graduation_project/features/Auth/presentation/Screens/startup_screen.dart';
import 'package:graduation_project/features/Home/presentation/screens/job_seeker_homeScreen.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => StartUpScreen()),
    GoRoute(
      path: '/login',
      name: '/login',
      builder: (context, state) => SignInScreen(),
    ),
    GoRoute(
      path: '/home',
      name: '/home',
      builder: (context, state) => JobSeekerHomeScreen(),
    ),
  ],
);
