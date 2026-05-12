import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/features/Applicants/presentation/cubit/applicants_cubit.dart';
import 'package:graduation_project/features/Applicants/presentation/cubit/applicants_state.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        onPressed: () {
          // هنا بناخد العدد الحقيقي اللي فاضل في الشاشة ونرجع بيه لبره
          final remaining = context.read<ApplicantsCubit>().state.applicants.length;
          Navigator.pop(context, remaining); 
        },
      ),
      title: BlocBuilder<ApplicantsCubit, ApplicantsState>(
        builder: (context, state) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Applicants', style: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeight.bold)),
            if (state.applicants.isNotEmpty)
              Text('${state.currentIndex + 1} of ${state.applicants.length}', style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}