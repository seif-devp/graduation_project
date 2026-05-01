import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_project/core/widgets/employer_navigation_bar.dart';
import 'package:graduation_project/features/Applicants/presentation/screen/application_screen.dart';
import 'package:graduation_project/features/Auth/presentation/Screens/sign_in_screen.dart';
import 'package:graduation_project/features/Auth/presentation/Screens/sign_up_screen.dart';
import 'package:graduation_project/features/Auth/presentation/Screens/startup_screen.dart';
import 'package:graduation_project/features/Auth/presentation/controller/auth_cubit.dart';
import 'package:graduation_project/features/Home/presentation/screens/job_seeker_homeScreen.dart';
import 'package:graduation_project/features/Home/presentation/Widgets/shell_layout.dart';
import 'package:graduation_project/features/Home_employer/presentation/screens/home_employer.dart';
import 'package:graduation_project/features/interviews/presentation/screens/interveiw_page.dart';
import 'package:graduation_project/features/interviews_employer/presentation/screens/interveiw_employer_page.dart';
import 'package:graduation_project/features/job_application_progress/presentation/screens/applying_progress.dart';
import 'package:graduation_project/features/job_details/screens/job_details.dart';
import 'package:graduation_project/features/job_list/domain/job_entity.dart';
import 'package:graduation_project/features/job_list/presentation/screens/jop_page.dart';
import 'package:graduation_project/features/post_job/presentation/screen/post_job.dart';
import 'package:graduation_project/features/profile/presentation/screens/profile_screen.dart';
import 'package:graduation_project/features/settings/data/repo.dart';
import 'package:graduation_project/features/settings/presentation/cubit/setting_cubit.dart';
import 'package:graduation_project/features/splash_screen/screen/splash_screen.dart';
import 'package:graduation_project/features/settings/presentation/screens/settings_page.dart';
import 'package:graduation_project/features/settings/presentation/screens/edit_profile_page.dart';
import 'package:graduation_project/features/Notifications/cubit/notification_cubit.dart';
import 'package:graduation_project/features/Notifications/presentation/pages/notifications_page.dart';
import 'package:graduation_project/features/job_application_progress/presentation/screens/application_detail_page.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final isEmployer = extra?['isEmployer'] as bool? ?? false;

        return BlocProvider(
          create: (_) => AuthCubit(),
          child: SignInScreen(initialEmployerSelected: isEmployer),
        );
      },
    ),
    GoRoute(
      path: '/startup',
      name: 'startup',
      builder: (context, state) => StartUpScreen(),
    ),
    GoRoute(
      path: '/signup',
      name: 'signup',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final isEmployer = extra?['isEmployer'] as bool? ?? false;

        return BlocProvider(
          create: (context) => AuthCubit(),
          child: SignUpScreen(initialEmployerSelected: isEmployer),
        );
      },
    ),
    GoRoute(
      path: '/edit_profile',
      name: 'edit_profile',
      builder: (context, state) => EditProfilePage(),
    ),
    GoRoute(
      path: '/job_details',
      name: 'job_details',
      builder: (context, state) =>
          JobDetailsPage(job: state.extra as JobEntity),
    ),
    GoRoute(
      path: '/alerts',
      name: 'alerts',
      redirect: (context, state) => '/notifications',
    ),
    GoRoute(
          path: '/application_detail',
          name: 'application_detail',
          builder: (context, state) {
            final data = state.extra as Map<String, dynamic>? ?? {};
            return ApplicationDetailPage(data: data);
          },
        ),

        GoRoute(
          path: '/notifications',
          name: 'notifications',
          builder: (context, state) => const NotificationsPage(),
        ),


        ///////// shell bta3 job seeker

    ShellRoute(
      builder: (context, state, child) => BlocProvider(
        create: (context) => NotificationCubit()..loadUnradCount(),
        child: ShellLayout(child: child),
      ),
      routes: [
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
            path: '/profile',
            name: 'profile',
            builder: (context, state) => ProfileScreen()),
      ],


      ////////////// shell bta3 employer

    ),
    ShellRoute(
        builder: (context, state, child) {
        return Scaffold(
          body: child, 
          bottomNavigationBar: const EmployerBottomNavBar(),
        );
      },
      routes: [
      GoRoute(
        path: '/home_employer',
        name: 'home_employer',
        builder: (context, state) => EmployerHomeScreen(),
      ),
      GoRoute(
          path: '/post_jobs_employer',
          name: 'post_jobs_employer',
          builder: (context, state) => PostJobScreen()),
      GoRoute(
        path: '/applications_swip',
        name: 'applications_swip',
        builder: (context, state) => ApplicantsScreen(),
      ),
      GoRoute(
        path: '/interview_employer',
        name: 'interview_employer',
        builder: (context, state) => InterviewsPageEmployer(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => BlocProvider(
          create: (context) =>
              SettingsCubit(SettingsRepository())..loadSettingsData(),
          child: const SettingsPage(),
        ),
      ),
    ]),


  ],
);
