import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/core/const/colors.dart';
import 'package:graduation_project/core/const/widgets.dart';
import 'package:graduation_project/features/choose_one_seeker_employerpage/presentation/cubit/choose_cubit.dart';
import 'package:graduation_project/features/choose_one_seeker_employerpage/presentation/cubit/choose_state.dart';


class ApplicantDetailsScreen
    extends StatelessWidget {

  final String applicationId;

  const ApplicantDetailsScreen({
    super.key,
    required this.applicationId,
  });

  @override
  Widget build(BuildContext context) {

    return BlocProvider(

      create: (_) => ApplicantDetailsCubit()
        ..getApplicantDetails(
          applicationId,
        ),

      child: Scaffold(

        backgroundColor:
            const Color(0xFFF8F9FF),

        appBar: AppBar(
          backgroundColor: primaryColor,
          title: const Text(
            'Applicant Details',
          ),
        ),

        body: BlocBuilder<
            ApplicantDetailsCubit,
            ApplicantDetailsState>(

          builder: (context, state) {

            if (state.status ==
                ApplicantDetailsStatus.loading) {

              return const Center(
                child:
                    loading,
              );
            }

            if (state.status ==
                ApplicantDetailsStatus.error) {

              return Center(
                child: Text(
                  state.errorMessage ?? '',
                ),
              );
            }

            final applicant =
                state.applicant!;

            return SingleChildScrollView(

              padding: EdgeInsets.all(20.w),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Center(
                    child: CircleAvatar(
                      radius: 50.r,

                      backgroundImage:
                          applicant.seekerAvatarUrl !=
                                  null
                              ? NetworkImage(
                                  applicant
                                      .seekerAvatarUrl!,
                                )
                              : null,

                      child:
                          applicant.seekerAvatarUrl ==
                                  null
                              ? const Icon(
                                  Icons.person,
                                  size: 50,
                                )
                              : null,
                    ),
                  ),

                  SizedBox(height: 20.h),

                  Center(
                    child: Text(
                      applicant.seekerName,

                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),

                  SizedBox(height: 10.h),

                  Center(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),

                      decoration: BoxDecoration(
                        color: primaryColor,

                        borderRadius:
                            BorderRadius.circular(
                          20.r,
                        ),
                      ),

                      child: Text(
                        '${applicant.aiMatchScore}% Match',

                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 30.h),

                  _buildTile(
                    'Job Title',
                    applicant.jobTitle,
                  ),

                  _buildTile(
                    'Company',
                    applicant.companyName,
                  ),

                  _buildTile(
                    'Resume',
                    applicant.resumeFileName,
                  ),

                  _buildTile(
                    'Status',
                    applicant.status,
                  ),

                  _buildTile(
                    'Applied At',
                    applicant.appliedAt,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTile(
    String title,
    String value,
  ) {

    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),

      child: Container(
        width: double.infinity,

        padding: EdgeInsets.all(16.w),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius:
              BorderRadius.circular(16.r),
        ),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            Text(
              title,

              style: TextStyle(
                color: Colors.grey,
                fontSize: 14.sp,
              ),
            ),

            SizedBox(height: 8.h),

            Text(
              value,

              style: TextStyle(
                fontSize: 16.sp,
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}