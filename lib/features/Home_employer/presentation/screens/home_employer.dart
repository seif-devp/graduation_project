import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/features/Home_employer/data/repo_imp.dart' show EmployerHomeRepository;
import 'package:graduation_project/features/Home_employer/presentation/cubit/home_employer_cubit.dart';
import 'package:graduation_project/features/Home_employer/presentation/cubit/home_employer_state.dart';
import 'package:graduation_project/features/Home_employer/widget/employer_header.dart';
import 'package:graduation_project/features/Home_employer/widget/quick_actions.dart';
import 'package:graduation_project/features/Home_employer/widget/recent_activity.dart';


class EmployerHomeScreen extends StatelessWidget {
  const EmployerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EmployerHomeCubit(EmployerHomeRepository())..getdata(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: BlocBuilder<EmployerHomeCubit, EmployerHomeState>(
          builder: (context, state) {
            if (state is EmployerHomeLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is EmployerHomeLoaded) {
              
              return SingleChildScrollView(
                child: Column(
                  children: [
                    
                    EmployerHeaderSection(data: state.data), 
                    
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                      child: const QuickActionsSection(),
                    ),
                    
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: const RecentActivitySection(),
                    ),
                    
                    SizedBox(height: 20.h),
                  ],
                ),
              );
            } else if (state is EmployerHomeError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}