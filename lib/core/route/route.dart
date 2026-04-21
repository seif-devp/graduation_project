
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_project/features/Auth/presentation/Screens/sign_in_screen.dart';
import 'package:graduation_project/features/Auth/presentation/Screens/startup_screen.dart';
import 'package:graduation_project/features/Auth/presentation/controller/auth_cubit.dart';
import 'package:graduation_project/features/Home/presentation/controller/job_Seeker_cubit.dart';
import 'package:graduation_project/features/Home/presentation/screens/job_seeker_homeScreen.dart';
import 'package:graduation_project/features/interviews/presentation/screens/interveiw_page.dart';
import 'package:graduation_project/features/job_list/presentation/screens/jop_page.dart';
import 'package:graduation_project/features/profile/presentation/screens/profile_screen.dart';

final router = GoRouter(
  routes: [

    GoRoute(
      path: '/',
      builder: (context, state) => InterviewsPage(),
    ),

    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => BlocProvider(
        create: (_) => AuthCubit(),
        child: SignInScreen(),
      ),
    ),

    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => BlocProvider(
        create: (_) => JobSeekerCubit(),
        child: JobSeekerHomeScreen(),
      ),
    ),
  
    GoRoute(
      path: '/jobPage',
      name: 'jobPage',
      builder:(context, state) => JobPage(),
      ),

    GoRoute(
      path: '/interveiw',
      name: 'interveiw',
      builder:(context, state) => InterviewsPage(),
      ),
  ],
     
);