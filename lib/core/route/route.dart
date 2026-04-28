import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_project/features/Auth/presentation/Screens/sign_in_screen.dart';
import 'package:graduation_project/features/Auth/presentation/Screens/sign_up_screen.dart';
import 'package:graduation_project/features/Auth/presentation/Screens/startup_screen.dart';
import 'package:graduation_project/features/Auth/presentation/controller/auth_cubit.dart';
import 'package:graduation_project/features/Home/presentation/screens/job_seeker_homeScreen.dart';
import 'package:graduation_project/features/Home/presentation/Widgets/shell_layout.dart';
import 'package:graduation_project/features/interviews/presentation/screens/interveiw_page.dart';
import 'package:graduation_project/features/job_application_progress/presentation/screens/applying_progress.dart';
import 'package:graduation_project/features/job_list/presentation/screens/jop_page.dart';
import 'package:graduation_project/features/profile/presentation/screens/profile_screen.dart';
import 'package:graduation_project/features/splash_screen/screen/splash_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => SplashScreen()),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) =>
          BlocProvider(create: (_) => AuthCubit(), child: SignInScreen()),
    ),
    ShellRoute(
      builder: (context, state, child) => ShellLayout(child: child),
      routes: [
        GoRoute(
          path: '/signup',
          name: 'signup',
          builder: (context, state) => BlocProvider(
            create: (context) => AuthCubit(),
            child: const SignUpScreen(),
          ),
        ),
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) => JobSeekerHomeScreen(),
        ),
        GoRoute(
          path: '/jobPage',
          name: 'jobPage',
          builder: (context, state) => JobPage(),
        ),
        GoRoute(
          path: '/applying',
          name: 'applying',
          builder: (context, state) => ApplicationProgressScreen(),
        ),
        GoRoute(
          path: '/interview',
          name: 'interview',
          builder: (context, state) => InterviewsPage(),
        ),
        GoRoute(
          path: '/alerts',
          name: 'alerts',
          builder: (context, state) => InterviewsPage(),
        ),
        GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (context, state) => ProfileScreen(),
        ),
      ],
    ),
  ],
);
