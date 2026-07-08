import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ✅ الـ imports الآن من الـ core والـ feature نفسها فقط
import 'package:graduation_project/features/profile/profile_seeker/widgets/Resume.dart';
import 'package:graduation_project/features/profile/profile_seeker/widgets/section_wrapper.dart';
import 'package:graduation_project/features/resume/presentation/cubit/resume_cubit.dart';

class ResumesSection extends StatelessWidget {
  const ResumesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ResumeCubit, ResumeState>(
      listener: (context, resumeState) {
        if (resumeState is ResumeActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(resumeState.message),
                backgroundColor: Colors.green),
          );
        } else if (resumeState is ResumeFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(resumeState.errorMessage),
                backgroundColor: Colors.red),
          );
        }
      },
      buildWhen: (previous, current) =>
          current is GetResumesLoading ||
          current is GetResumesSuccess ||
          current is GetResumesFailure,
      builder: (context, resumeState) {
        return Frame(
          title: "My Resumes",
          icon: Icons.description_outlined,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () async {
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['pdf', 'doc', 'docx'],
                      );
                      if (result != null && result.files.single.path != null) {
                        // ignore: use_build_context_synchronously
                        context.read<ResumeCubit>().uploadResume(
                              result.files.single.path!,
                              isFromProfile: true,
                            );
                      }
                    },
                    icon: const Icon(Icons.upload, size: 18),
                    label: const Text("Upload"),
                  ),
                ],
              ),
              SizedBox(height: 5.h),
              if (resumeState is GetResumesLoading ||
                  resumeState is ResumeActionLoading)
                const Center(child: CircularProgressIndicator())
              else if (resumeState is GetResumesFailure)
                Center(
                    child: Text(resumeState.errorMessage,
                        style: const TextStyle(color: Colors.red)))
              else if (resumeState is GetResumesSuccess)
                resumeState.resumes.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text("No resumes uploaded yet.",
                            style: TextStyle(color: Colors.grey)),
                      )
                    : Column(
                        children: resumeState.resumes.map((resume) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 10.h),
                            child: ResumeItem(
                              resume: resume, // ✅ بتباصي الموديل كامل هنا
                              actions: [
                                // زرار الـ Default (النجمة) بس اللي هيفضل موجود
                                IconButton(
                                  icon: Icon(
                                    resume.isDefault
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: resume.isDefault
                                        ? Colors.amber
                                        : Colors.grey,
                                  ),
                                  onPressed: () => context
                                      .read<ResumeCubit>()
                                      .setDefaultResume(resume.id),
                                ),
                                // ❌ تم إزالة زرار الحذف (Delete) بالكامل من هنا
                              ],
                            ),
                          );
                        }).toList(),
                      )
            ],
          ),
        );
      },
    );
  }
}
