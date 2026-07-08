import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_project/features/settings/setting_employer/data/entitiy.dart';
import '../cubit/setting_cubit.dart';

class EditProfilePageEmployer extends StatefulWidget {
  final UserEntity? user; 

  const EditProfilePageEmployer({super.key, this.user}); 

  @override
  State<EditProfilePageEmployer> createState() => _EditProfilePageEmployerState();
}

class _EditProfilePageEmployerState extends State<EditProfilePageEmployer> {
  // Basic Info
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _bioCtrl;
  
  // Company Info
  late final TextEditingController _companyNameCtrl;
  late final TextEditingController _industryCtrl;
  late final TextEditingController _websiteCtrl;
  late final TextEditingController _sizeCtrl;
  
  String? _selectedAvatarPath;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.user?.name ?? '');
    _emailCtrl = TextEditingController(text: widget.user?.email ?? '');
    _phoneCtrl = TextEditingController(text: widget.user?.phone ?? '');
    _bioCtrl = TextEditingController(text: widget.user?.bio ?? '');

    _companyNameCtrl = TextEditingController(text: widget.user?.companyName ?? '');
    _industryCtrl = TextEditingController(text: widget.user?.industry ?? '');
    _sizeCtrl = TextEditingController(text: widget.user?.companySize ?? '');
    _websiteCtrl = TextEditingController(text: widget.user?.website ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _bioCtrl.dispose();
    _companyNameCtrl.dispose();
    _industryCtrl.dispose();
    _websiteCtrl.dispose();
    _sizeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color myPrimaryBlue = Color(0xFF033B7A);
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: myPrimaryBlue,
        leading: const BackButton(color: Colors.white),
        title: const Text('Edit Profile', style: TextStyle(color: Colors.white)),
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
                    // --- Avatar Section ---
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
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
                            backgroundColor: myPrimaryBlue.withOpacity(0.1),
                            backgroundImage: _selectedAvatarPath != null
                                ? FileImage(File(_selectedAvatarPath!))
                                : (widget.user?.avatarUrl != null && widget.user!.avatarUrl!.isNotEmpty)
                                    ? NetworkImage(widget.user!.avatarUrl!) as ImageProvider
                                    : null,
                            child: _selectedAvatarPath == null &&
                                    (widget.user?.avatarUrl == null || widget.user!.avatarUrl!.isEmpty)
                                ? Icon(Icons.business, size: 44, color: myPrimaryBlue)
                                : null,
                          ),
                          const SizedBox(height: 12),
                          OutlinedButton.icon(
                            onPressed: () async {
                              final result = await FilePicker.platform.pickFiles(
                                type: FileType.image,
                                allowMultiple: false,
                              );
                              if (result != null && result.files.single.path != null) {
                                setState(() {
                                  _selectedAvatarPath = result.files.single.path;
                                });
                              }
                            },
                            icon: const Icon(Icons.upload_outlined, size: 16),
                            label: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Text('Change Logo/Photo', style: TextStyle(fontSize: 13)),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.grey.shade300),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // --- Basic Info Section ---
                    _buildCard(
                      title: 'Basic Information',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildTextField(controller: _nameCtrl, label: 'Full Name'),
                          const SizedBox(height: 14),
                          _buildTextField(controller: _emailCtrl, label: 'Email', isReadOnly: true),
                          const SizedBox(height: 14),
                          _buildTextField(controller: _phoneCtrl, label: 'Phone Number'),
                          const SizedBox(height: 14),
                          _buildTextField(controller: _bioCtrl, label: 'Bio', maxLines: 4),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // --- Company Info Section ---
                    _buildCard(
                      title: 'Company Information',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildTextField(controller: _companyNameCtrl, label: 'Company Name'),
                          const SizedBox(height: 14),
                          _buildTextField(controller: _industryCtrl, label: 'Industry'),
                          const SizedBox(height: 14),
                          _buildTextField(controller: _sizeCtrl, label: 'Company Size (e.g. Startup)'),
                          const SizedBox(height: 14),
                          _buildTextField(controller: _websiteCtrl, label: 'Website URL'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // --- Buttons ---
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => context.pop(),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.grey.shade300),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              backgroundColor: Colors.white,
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 14),
                              child: Text('Cancel', style: TextStyle(color: Colors.black87)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: BlocBuilder<SettingsCubit, SettingsState>(builder: (context, state) {
                            return ElevatedButton(
                              onPressed: state.isLoading
                                  ? null
                                  : () {
                                      context.read<SettingsCubit>().saveFullProfile(
                                            name: _nameCtrl.text,
                                            phone: _phoneCtrl.text,
                                            bio: _bioCtrl.text,
                                            companyName: _companyNameCtrl.text,
                                            companySize: _sizeCtrl.text,
                                            industry: _industryCtrl.text,
                                            website: _websiteCtrl.text,
                                            avatarFilePath: _selectedAvatarPath,
                                            context: context,
                                          );
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2F6FF6),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                child: state.isLoading
                                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                    : const Text('Save Changes', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
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

  Widget _buildTextField({required TextEditingController controller, required String label, int maxLines = 1, bool isReadOnly = false}) {
    final lightFill = const Color(0xFFF3F7FA);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey.shade800)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          readOnly: isReadOnly,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            filled: true,
            fillColor: Theme.of(context).brightness == Brightness.light ? lightFill : Colors.grey.shade800,
          ),
          style: TextStyle(fontSize: 14, color: isReadOnly ? Colors.grey : null),
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
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}