import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:graduation_project/features/job_list/data/models/job_model_response.dart';

class JobCardwidgetEmployer extends StatefulWidget {

  const JobCardwidgetEmployer({
    super.key,
    required this.job,
    this.onTap,
  });

  final JobModelResponse job;

  final VoidCallback? onTap;

  @override
  State<JobCardwidgetEmployer> createState() =>
      _JobCardwidgetEmployerState();
}

class _JobCardwidgetEmployerState
    extends State<JobCardwidgetEmployer> {

  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {

    return InkWell(

      onTap: widget.onTap,

      child: Container(

        margin: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 10.h,
        ),

        padding: EdgeInsets.all(20.w),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius:
              BorderRadius.circular(20.r),

          border: Border.all(
            color: Colors.blue.shade100,
            width: 1.5.w,
          ),
        ),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            /// Top Row
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,

              children: [

                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.blue,

                    borderRadius:
                        BorderRadius.circular(
                      20.r,
                    ),
                  ),

                  child: Text(
                    "${widget.job.applicationCount} Applicants",

                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                /// Favorite
                IconButton(
                  onPressed: () {

                    setState(() {
                      isFavorite = !isFavorite;
                    });
                  },

                  icon: Icon(
                    isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,

                    color: isFavorite
                        ? Colors.red
                        : Colors.grey,
                  ),
                ),
              ],
            ),

            SizedBox(height: 15.h),

            /// Job Title
            Text(
              widget.job.title,

              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 5.h),

            /// Company
            Text(
              widget.job.companyName,

              style: TextStyle(
                color: Colors.grey,
                fontSize: 18.sp,
              ),
            ),

            SizedBox(height: 20.h),

            /// Location
            _infoRow(
              Icons.location_on_outlined,
              widget.job.location,
            ),

            SizedBox(height: 8.h),

            /// Salary
            _infoRow(
              Icons.attach_money,
              widget.job.salary,
            ),

            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(
    IconData icon,
    String text,
  ) {

    return Row(
      children: [

        Icon(
          icon,

          size: 18.sp,

          color: Colors.grey.shade400,
        ),

        SizedBox(width: 10.w),

        Text(
          text,

          style: const TextStyle(
            color: Colors.blueGrey,
          ),
        ),
      ],
    );
  }
}