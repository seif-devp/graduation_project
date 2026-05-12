import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_project/core/const/colors.dart';
import 'package:graduation_project/features/settings/setting_employer/logic/entitiy.dart';
import '../cubit/setting_cubit.dart';

class EditProfilePageEmployer extends StatefulWidget {
  final UserEntity? user; // 1. استقبلنا المتغير هنا

  const EditProfilePageEmployer({super.key, this.user}); // ضفناه في الـ Constructor

  @override
  State<EditProfilePageEmployer> createState() => _EditProfilePageEmployerState();
}

class _EditProfilePageEmployerState extends State<EditProfilePageEmployer> {
  late final TextEditingController _companyNameCtrl;
  late final TextEditingController _industryCtrl;
  late final TextEditingController _websiteCtrl;
  late final TextEditingController _sizeCtrl;

  @override
  void initState() {
    super.initState();
    // 2. بنملى الحقول بالداتا القديمة لو موجودة 
    // (لاحظ: لازم تتأكد إن UserEntity بتاعك جواه المتغيرات دي، لو مش جواه ضيفهم فيه)
    _companyNameCtrl = TextEditingController(text: widget.user?.companyName ?? '');
    _industryCtrl = TextEditingController(text: widget.user?.industry ?? '');
    _sizeCtrl = TextEditingController(text: widget.user?.companySize ?? '');
    _websiteCtrl = TextEditingController(text: widget.user?.website ?? '');
  }

  @override
  void dispose() {
    _companyNameCtrl.dispose();
    _industryCtrl.dispose();
    _websiteCtrl.dispose();
    _sizeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: const BackButton(color: Colors.white),
        title: const Text('Edit Company Profile', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(controller: _companyNameCtrl, label: 'Company Name'),
            const SizedBox(height: 16),
            _buildTextField(controller: _industryCtrl, label: 'Industry'),
            const SizedBox(height: 16),
            _buildTextField(controller: _sizeCtrl, label: 'Company Size (e.g. Startup)'),
            const SizedBox(height: 16),
            _buildTextField(controller: _websiteCtrl, label: 'Website URL'),
            const SizedBox(height: 32),
            
            BlocBuilder<SettingsCubit, SettingsState>(
              builder: (context, state) {
                return SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: state.isLoading ? null : () {
                      context.read<SettingsCubit>().saveCompanyInfo(
                        companyName: _companyNameCtrl.text,
                        companySize: _sizeCtrl.text,
                        industry: _industryCtrl.text,
                        website: _websiteCtrl.text,
                        context: context,
                      );
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2F6FF6)),
                    child: state.isLoading 
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Save Changes', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String label}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF3F7FA),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }
}