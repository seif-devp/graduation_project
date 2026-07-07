import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/features/profile/profile_seeker/widgets/Resume.dart';
import 'package:graduation_project/features/resume/data/model.dart';
import 'package:graduation_project/features/resume/data/remote.dart';
import 'package:graduation_project/features/resume/data/repo.dart';
import 'package:graduation_project/features/resume/presentation/cubit/resume_cubit.dart';

class ResumeSelectionDialog extends StatelessWidget {
  const ResumeSelectionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResumeCubit(
        ResumeRepository(
          ResumeRemoteDataSource(),
        ),
      )..getResumes(),
      child: AlertDialog(
        title: const Text('Select a Resume'),
        content: BlocBuilder<ResumeCubit, ResumeState>(
          builder: (context, state) {
            if (state is GetResumesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GetResumesFailure) {
              return Text(state.errorMessage);
            } else if (state is GetResumesSuccess) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...state.resumes.map((resume) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop(resume);
                          },
                          child: ResumeItem(
                            resume: resume,
                            actions: const [],
                          ),
                        ),
                      );
                    }).toList(),
                    SizedBox(height: 10.h),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop('upload_new');
                      },
                      icon: const Icon(Icons.upload_file),
                      label: const Text('Upload New Resume'),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
