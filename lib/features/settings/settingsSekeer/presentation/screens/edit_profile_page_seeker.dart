import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_project/core/const/colors.dart';
import 'package:graduation_project/core/const/widgets.dart';
import 'package:graduation_project/features/settings/settingsSekeer/logic/entitiy.dart';
import 'package:graduation_project/features/settings/settingsSekeer/presentation/cubit/settingSeeker_cubit.dart';
import 'package:graduation_project/features/settings/settingsSekeer/presentation/cubit/settingseeker_state.dart';

class EditProfilePageSeeker extends StatefulWidget {
  final SeekerEntity? user; // استقبلنا اليوزر هنا

  const EditProfilePageSeeker({super.key, this.user});

  @override
  State<EditProfilePageSeeker> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePageSeeker> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _bioCtrl;
  String? _selectedAvatarPath;

  @override
  void initState() {
    super.initState();
    // بنربط الداتا اللي جاية من الـ API بالحقول
    _nameCtrl = TextEditingController(text: widget.user?.name ?? '');
    _emailCtrl = TextEditingController(text: widget.user?.email ?? '');
    _phoneCtrl = TextEditingController(text: widget.user?.phone ?? '');
    _bioCtrl = TextEditingController(text: widget.user?.bio ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: const BackButton(color: Colors.white),
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        final maxWidth = constraints.maxWidth > 700 ? 700.0 : double.infinity;
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 44,
                            backgroundImage: _selectedAvatarPath != null
                                ? FileImage(File(_selectedAvatarPath!))
                                : (widget.user?.avatarUrl != null &&
                                        widget.user!.avatarUrl!.isNotEmpty
                                    ? NetworkImage(widget.user!.avatarUrl!)
                                        as ImageProvider
                                    : null),
                            child: _selectedAvatarPath == null &&
                                    (widget.user?.avatarUrl == null ||
                                        widget.user!.avatarUrl!.isEmpty)
                                ? const Icon(Icons.person, size: 44)
                                : null,
                          ),
                          const SizedBox(height: 12),
                          OutlinedButton.icon(
                            onPressed: () async {
                              final result =
                                  await FilePicker.platform.pickFiles(
                                type: FileType.image,
                                allowMultiple: false,
                              );
                              if (result != null &&
                                  result.files.single.path != null) {
                                setState(() {
                                  _selectedAvatarPath =
                                      result.files.single.path;
                                });
                              }
                            },
                            icon: const Icon(Icons.upload_outlined, size: 16),
                            label: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Text('Change Photo',
                                  style: TextStyle(fontSize: 13)),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.grey.shade300),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black87,
                              elevation: 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildCard(
                      title: 'Basic Information',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildTextField(
                              controller: _nameCtrl, label: 'Full Name'),
                          const SizedBox(height: 14),
                          _buildTextField(
                              controller: _emailCtrl,
                              label: 'Email',
                              isReadOnly: true),
                          const SizedBox(height: 14),
                          _buildTextField(
                              controller: _phoneCtrl, label: 'Phone Number'),
                          const SizedBox(height: 14),
                          _buildTextField(
                              controller: _bioCtrl, label: 'Bio', maxLines: 4),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildCard(
                      title: 'My Resumes',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.upload_file, size: 16),
                              label: const Text('Upload'),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.grey.shade300),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildResumeTile(
                              'Sarah_Johnson_Resume_2026.pdf', '15/01/2026'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => context.pop(),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.grey.shade300),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              backgroundColor: Colors.white,
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 14),
                              child: Text('Cancel',
                                  style: TextStyle(color: Colors.black87)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child:
                              BlocBuilder<SettingsSeekerCubit, SettingsState>(
                                  builder: (context, state) {
                            return ElevatedButton(
                              onPressed: state.isLoading
                                  ? null
                                  : () {
                                      context
                                          .read<SettingsSeekerCubit>()
                                          .saveProfileChanges(
                                            name: _nameCtrl.text,
                                            phone: _phoneCtrl.text,
                                            bio: _bioCtrl.text,
                                            avatarFilePath: _selectedAvatarPath,
                                            context: context,
                                          );
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2F6FF6),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                child: state.isLoading
                                    ? const SizedBox(
                                        height: 20, width: 20, child: loading)
                                    : const Text(
                                        'Save Changes',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    bool isReadOnly = false,
  }) {
    final lightFill = const Color(0xFFF3F7FA);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          readOnly: isReadOnly, // تفعيل القراءة فقط
          decoration: InputDecoration(
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Theme.of(context).brightness == Brightness.light
                ? lightFill
                : Colors.grey.shade800,
          ),
          style: TextStyle(
              fontSize: 14,
              color:
                  isReadOnly ? Colors.grey : null // لو مقفول نخليه لونه رمادي
              ),
        ),
      ],
    );
  }

  Widget _buildCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildResumeTile(String name, String date) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).brightness == Brightness.light
            ? const Color(0xFFEEF7FF)
            : Colors.grey.shade800,
        border: Border.all(color: Colors.transparent),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(date,
                    style:
                        TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Text('PDF',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
