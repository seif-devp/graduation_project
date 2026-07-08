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
import 'package:graduation_project/features/Notifications/notification_seeker/data/remote_data.dart';
import 'package:graduation_project/features/Notifications/notification_seeker/data/repo.dart';
import 'package:graduation_project/features/Notifications/notification_seeker/presentation/cubit/note_cubit.dart';
import 'package:graduation_project/features/interviews/interviews_seeker/presentation/screens/interveiw_page.dart';
import 'package:graduation_project/features/interviews/interviews_employer/presentation/screens/interveiw_employer_page.dart';
import 'package:graduation_project/features/job_application_progress/presentation/screens/applying_progress.dart';
import 'package:graduation_project/features/job_application_progress/data/repo.dart';
import 'package:graduation_project/features/job_application_progress/data/remore_source.dart';
import 'package:graduation_project/features/job_application_progress/presentation/cubit/application_progress_cubit.dart';
import 'package:graduation_project/features/job_details/screens/job_details.dart';
import 'package:graduation_project/features/job_list/data/models/job_model_response.dart';
import 'package:graduation_project/features/job_list/domain/job_entity.dart';
import 'package:graduation_project/features/job_list/presentation/screens/jop_page.dart';
import 'package:graduation_project/features/post_job/presentation/screen/post_job.dart';
import 'package:graduation_project/features/profile/profile_seeker/presentation/screens/profile_screen.dart';
import 'package:graduation_project/features/resume/presentation/screen/page.dart';
import 'package:graduation_project/features/settings/setting_employer/logic/repo.dart';
import 'package:graduation_project/features/settings/setting_employer/data/entitiy.dart';
import 'package:graduation_project/features/settings/setting_employer/presentation/cubit/setting_cubit.dart';
import 'package:graduation_project/features/settings/settingsSekeer/data/repoSeeker.dart';
import 'package:graduation_project/features/settings/settingsSekeer/logic/entitiy.dart';
import 'package:graduation_project/features/settings/settingsSekeer/presentation/cubit/settingSeeker_cubit.dart';
import 'package:graduation_project/features/settings/settingsSekeer/presentation/screens/edit_profile_page_seeker.dart';
import 'package:graduation_project/features/settings/settingsSekeer/presentation/screens/settings_page.dart';
import 'package:graduation_project/features/splash_screen/screen/splash_screen.dart';
import 'package:graduation_project/features/settings/setting_employer/presentation/screens/settings_page.dart';
import 'package:graduation_project/features/settings/setting_employer/presentation/screens/edit_profile_page.dart';
import 'package:graduation_project/features/Notifications/notification_seeker/presentation/pages/notifications_page.dart';
import 'package:graduation_project/features/job_application_progress/presentation/screens/application_detail_page.dart';

// ✅ Global navigator key: بيسمحلنا نفتح شاشات (زي الـ Chat Bot) من أي مكان
// في التطبيق من غير ما نعتمد على الـ context بتاع شاشة معينة.
final rootNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: rootNavigatorKey,
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
      builder: (context, state) {
        final extra = state.extra;
        final jobId = extra is String ? extra : null;
        return ResumeUploadScreen(jobId: jobId);
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
      builder: (context, state) {
        final user = state.extra as SeekerEntity?;

        return BlocProvider(
          create: (context) => SettingsSeekerCubit(SettingsSekeerRepository()),
          child: EditProfilePageSeeker(user: user),
        );
      },
    ),
    GoRoute(
      path: '/edit_profile_employer',
      name: 'edit_profile_employer',
      builder: (context, state) {
        // 1. نستقبل داتا الشركة اللي مبعوتة
        final user = state.extra as UserEntity?;

        // 2. نعمل Cubit جديد خاص بشاشة التعديل دي بس
        return BlocProvider(
          create: (context) => SettingsCubit(SettingsRepository()),
          child: EditProfilePageEmployer(user: user),
        );
      },
    ),
    GoRoute(
      path: '/job_details',
      name: 'job_details',
      builder: (context, state) {
        final extra = state.extra;
        String jobId = '';
        if (extra is JobModelResponse) {
          jobId = extra.id;
        } else if (extra is JobEntity) {
          jobId = extra.id;
        } else if (extra is Map) {
          jobId = extra['id']?.toString() ?? '';
        }
        return JobDetailsPage(jobId: jobId);
      },
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

    ///////// shell bta3 job seeker

    ShellRoute(
      builder: (context, state, child) => BlocProvider(
        create: (context) => NotificationCubit(
            NotificationRepository(NotificationRemoteDataSource()))
          ..fetchNotifications(),
        child: ShellLayout(child: child),
      ),
      routes: [
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) => JobSeekerHomeScreen(),
        ),
        GoRoute(
          path: '/notifications',
          name: 'notifications',
          builder: (context, state) => const NotificationsPage(),
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
          return BlocProvider(
            create: (context) =>
                NotificationCubitEmployer()..fetchNotifications(),
            child: Scaffold(
              body: child,
              bottomNavigationBar: const EmployerBottomNavBar(),
            ),
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
            path: '/notificationsEmployer',
            name: 'notificationsEmployer',
            builder: (context, state) => BlocProvider(
              create: (context) => NotificationCubitEmployer(),
              child: const NotificationsPageEmployer(),
            ),
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