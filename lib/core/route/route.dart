import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_project/core/widgets/employer_navigation_bar.dart';
import 'package:graduation_project/features/Applicants/data/remote_data_source.dart';
import 'package:graduation_project/features/Applicants/data/repo_application.dart';
import 'package:graduation_project/features/Applicants/presentation/cubit/applicants_cubit.dart';
import 'package:graduation_project/features/Applicants/presentation/screen/view_job.dart';
import 'package:graduation_project/features/Auth/presentation/Screens/sign_in_screen.dart';
import 'package:graduation_project/features/Auth/presentation/Screens/sign_up_screen.dart';
import 'package:graduation_project/features/Auth/presentation/Screens/startup_screen.dart';
import 'package:graduation_project/features/Auth/presentation/controller/auth_cubit.dart';
import 'package:graduation_project/features/Home/Home_employer/data/remote_data_source_eployer.dart';
import 'package:graduation_project/features/Home/Home_employer/data/repo_imp.dart';
import 'package:graduation_project/features/Home/Home_employer/presentation/cubit/home_employer_cubit.dart';
import 'package:graduation_project/features/Home/Home_employer/presentation/screens/my_jobs.dart';
import 'package:graduation_project/features/Home/home_seeker/presentation/screens/job_seeker_homeScreen.dart';
import 'package:graduation_project/features/Home/home_seeker/presentation/Widgets/shell_layout.dart';
import 'package:graduation_project/features/Home/Home_employer/presentation/screens/home_employer.dart';
import 'package:graduation_project/features/Notifications/notification_employer/cubit/notification_Employer_cubit.dart';
import 'package:graduation_project/features/Notifications/notification_employer/presentation/pages/notifications_Employer_page.dart';
import 'package:graduation_project/features/interviews/interviews_seeker/presentation/screens/interveiw_page.dart';
import 'package:graduation_project/features/interviews/interviews_employer/presentation/screens/interveiw_employer_page.dart';
import 'package:graduation_project/features/job_application_progress/presentation/screens/applying_progress.dart';
import 'package:graduation_project/features/job_application_progress/data/repo.dart';
import 'package:graduation_project/features/job_application_progress/data/remore_source.dart';
import 'package:graduation_project/features/job_application_progress/presentation/cubit/application_progress_cubit.dart';
import 'package:graduation_project/features/job_details/screens/job_details.dart';
import 'package:graduation_project/features/job_list/presentation/screens/jop_page.dart';
import 'package:graduation_project/features/post_job/presentation/screen/post_job.dart';
import 'package:graduation_project/features/profile/presentation/screens/profile_screen.dart';
import 'package:graduation_project/features/resume/presentation/screen/page.dart';
import 'package:graduation_project/features/settings/setting_employer/data/repo.dart';
import 'package:graduation_project/features/settings/setting_employer/presentation/cubit/setting_cubit.dart';
import 'package:graduation_project/features/settings/settingsSekeer/data/repoSeeker.dart';
import 'package:graduation_project/features/settings/settingsSekeer/presentation/cubit/settingSeeker_cubit.dart';
import 'package:graduation_project/features/settings/settingsSekeer/presentation/screens/settings_page.dart';
import 'package:graduation_project/features/splash_screen/screen/splash_screen.dart';
import 'package:graduation_project/features/settings/setting_employer/presentation/screens/settings_page.dart';
import 'package:graduation_project/features/settings/setting_employer/presentation/screens/edit_profile_page.dart';
import 'package:graduation_project/features/Notifications/notification_seeker/cubit/notification_cubit.dart';
import 'package:graduation_project/features/Notifications/notification_seeker/presentation/pages/notifications_page.dart';
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
      path: '/sign_up',
      name: 'sign_up',
      builder: (context, state) => SignUpScreen(),
    ),

    GoRoute(
      path: '/resume_upload',
      name: 'resume_upload',
      builder: (context, state) => ResumeUploadScreen(),
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
          JobDetailsPage(jobId: (state.extra as dynamic).id.toString()),
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
      builder: (context, state) => BlocProvider(
        create: (context) => NotificationCubit(),
        child: const NotificationsPage(),
      ),
    ),
    GoRoute(
      path: '/notificationsEmployer',
      name: 'notificationsEmployer',
      builder: (context, state) => BlocProvider(
        create: (context) => NotificationCubitEmployer(),
        child: const NotificationsPageEmployer(),
      ),
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
          builder: (context, state) => BlocProvider(
            create: (context) => ApplicationProgressCubit(
                SeekerApplicationRepoImpl(SeekerApplicationRemoteDataSource()))
              ..getMyApplications(),
            child: ApplicationProgressScreen(),
          ),
        ),
        GoRoute(
          path: '/interview',
          name: 'interview',
          builder: (context, state) => InterviewsPage(),
        ),
        GoRoute(
          path: '/settingsSeeker',
          name: 'settingsSeeker',
          builder: (context, state) => BlocProvider(
            create: (context) => SettingsSeekerCubit(SettingsSekeerRepository())
              ..loadSettingsData(),
            child: const SettingsPageSeeker(),
          ),
        ),
        GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => ProfileScreen()),
      ],

      ////////////// shell bta3 employer
    ),

    GoRoute(
      path: '/my_job_employer',
      name: 'my_job_employer',
      builder: (context, state) => BlocProvider(
        create: (context) => EmployerHomeCubit(
            EmployerHomeRepository(RemoteDataSourceEployer())),
        child: MyJobsScreen(),
      ),
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
            path: '/JobPage_employer',
            name: 'JobPage_employer',
            builder: (context, state) => BlocProvider(
              create: (context) => ApplicantsCubit(
                  ApplicantsRepository(ApplicantsRemoteDataSource())),
              child: JobPageEmployer(),
            ),
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
