import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/core/const/colors.dart';
import 'package:graduation_project/core/const/widgets.dart';
import 'package:graduation_project/core/widgets/text_field_post_job.dart';
import 'package:graduation_project/features/post_job/data/remote_data.dart';
import 'package:graduation_project/features/post_job/data/repo_imp_.dart';
import 'package:graduation_project/features/post_job/presentation/cubit/post_lob_cubit.dart';
import 'package:graduation_project/features/post_job/presentation/cubit/post_lob_state.dart';

class PostJobScreen extends StatefulWidget {
  const PostJobScreen({super.key});

  @override
  State<PostJobScreen> createState() => _PostJobScreenState();
}

class _PostJobScreenState extends State<PostJobScreen> {
  final titleController = TextEditingController();
  final companyController = TextEditingController();
  final locationController = TextEditingController();
  final salaryController = TextEditingController();
  final jobTypeController = TextEditingController();
  final descriptionController = TextEditingController();
  final requirementController = TextEditingController();

  DateTime? selectedExpiryDate;

  @override
  void dispose() {
    titleController.dispose();
    companyController.dispose();
    locationController.dispose();
    salaryController.dispose();
    jobTypeController.dispose();
    descriptionController.dispose();
    requirementController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => selectedExpiryDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostJobCubit(
          JobEmployerRepositoryImpl(RemoteDataPostJob())),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: primaryColor,
          elevation: 0,
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Post a Job',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              Text(
                'Find the perfect candidate',
                style: TextStyle(
                  color: Color.fromARGB(255, 168, 187, 212),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        body: BlocConsumer<PostJobCubit, PostJobState>(
          listener: (context, state) {
            if (state is PostJobSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Job Posted Successfully!')),
              );
            } else if (state is PostJobFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(state.errorMessage),
                    backgroundColor: Colors.red),
              );
            }
          },
          builder: (context, state) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomTextField(
                          label: 'Job Title',
                          hint: 'e.g., Senior React Developer',
                          controller: titleController,
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          label: 'Company Name',
                          hint: 'Your company name',
                          controller: companyController,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                label: 'Location',
                                hint: 'e.g., Remote',
                                controller: locationController,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: CustomTextField(
                                label: 'Salary Range',
                                hint: 'e.g., 5000',
                                controller: salaryController,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          label: 'Job Type',
                          hint: 'e.g., Full-time',
                          controller: jobTypeController,
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          label: 'Job Description',
                          hint: 'Describe the role and responsibilities...',
                          controller: descriptionController,
                          maxLines: 4,
                        ),
                        const SizedBox(height: 16),

                        const Text(
                          'Deadline',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () => _pickDate(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.calendar_today,
                                    color: primaryColor, size: 18),
                                const SizedBox(width: 8),
                                Text(
                                  selectedExpiryDate != null
                                      ? '${selectedExpiryDate!.year}-${selectedExpiryDate!.month.toString().padLeft(2, '0')}-${selectedExpiryDate!.day.toString().padLeft(2, '0')}'
                                      : 'Select expiry date',
                                  style: TextStyle(
                                    color: selectedExpiryDate != null
                                        ? Colors.black87
                                        : const Color(0xFF94A3B8),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Requirements
                        const Text(
                          'Requirements',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: requirementController,
                                decoration: InputDecoration(
                                  hintText: 'Add a skill or requirement',
                                  hintStyle: const TextStyle(
                                      color: Color(0xFF94A3B8), fontSize: 14),
                                  filled: true,
                                  fillColor: const Color(0xFFF8FAFC),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 14),
                                ),
                                onSubmitted: (value) {
                                  context
                                      .read<PostJobCubit>()
                                      .addRequirement(value);
                                  requirementController.clear();
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            InkWell(
                              onTap: () {
                                context
                                    .read<PostJobCubit>()
                                    .addRequirement(requirementController.text);
                                requirementController.clear();
                              },
                              child: Container(
                                height: 48,
                                width: 48,
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.add, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        if (context
                            .read<PostJobCubit>()
                            .currentRequirements
                            .isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Wrap(
                              spacing: 8.0,
                              runSpacing: 8.0,
                              children: context
                                  .read<PostJobCubit>()
                                  .currentRequirements
                                  .map((req) {
                                return Chip(
                                  label: Text(req),
                                  deleteIcon:
                                      const Icon(Icons.close, size: 16),
                                  onDeleted: () {
                                    context
                                        .read<PostJobCubit>()
                                        .removeRequirement(req);
                                  },
                                  backgroundColor: const Color(0xFFEFF6FF),
                                  labelStyle: const TextStyle(
                                      color: Color(0xFF1E40AF)),
                                  side: BorderSide.none,
                                );
                              }).toList(),
                            ),
                          ),
                        const SizedBox(height: 32),

                        // Submit Button
                        SizedBox(
                          height: 52,
                          child: ElevatedButton(
                            onPressed: state is PostJobLoading
                                ? null
                                : () {
                                    if (selectedExpiryDate == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Please select expiry date')),
                                      );
                                      return;
                                    }
                                    context.read<PostJobCubit>().submitJobPost(
                                          title: titleController.text,
                                          companyName: companyController.text,
                                          location: locationController.text,
                                          salaryRange: salaryController.text,
                                          jobType: jobTypeController.text,
                                          description: descriptionController.text,
                                          expiresAt: selectedExpiryDate!,
                                        );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 0,
                            ),
                            child: state is PostJobLoading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: loading,
                                  )
                                : const Text(
                                    'Post Job',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}