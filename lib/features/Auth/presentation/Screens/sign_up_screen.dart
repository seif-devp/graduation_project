import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_project/core/const/widgets.dart';
import 'package:graduation_project/features/Auth/presentation/controller/auth_cubit.dart';
import 'package:lottie/lottie.dart';

class SignUpScreen extends StatefulWidget {
  final bool initialEmployerSelected;

  const SignUpScreen({super.key, this.initialEmployerSelected = false});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late bool isEmployerSelected;
  bool isPasswordVisible = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // ألوان الهوية البصرية
  final Color primaryDarkBlue = const Color.fromARGB(255, 3, 59, 122);
  final Color accentCyan = const Color(0xFF00F2FE);

  @override
  void initState() {
    super.initState();
    isEmployerSelected = widget.initialEmployerSelected;
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Creating account...')),
          );
        }
        if (state is AuthSuccess) {
          context.go('/home'); // النقل التلقائي بعد نجاح التسجيل
        }
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error occurred while signing up')),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FF), // نفس الخلفية الفاتحة
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 32.h),
                Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.bold,
                    color: primaryDarkBlue, // تطعيم بالكحلي
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Sign up to get started',
                  style: TextStyle(fontSize: 16.sp, color: Colors.black54),
                ),
                SizedBox(height: 32.h),

                /// Toggle Buttons (Job Seeker / Employer)
                Container(
                  height: 52.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              setState(() => isEmployerSelected = false),
                          child: Container(
                            decoration: BoxDecoration(
                              color: !isEmployerSelected
                                  ? primaryDarkBlue // الاختيار النشط بالكحلي
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(26),
                            ),
                            child: Center(
                              child: Text(
                                'Job Seeker',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: !isEmployerSelected
                                      ? Colors.white
                                      : Colors.black54,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              setState(() => isEmployerSelected = true),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isEmployerSelected
                                  ? primaryDarkBlue // الاختيار النشط بالكحلي
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(26),
                            ),
                            child: Center(
                              child: Text(
                                'Employer',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isEmployerSelected
                                      ? Colors.white
                                      : Colors.black54,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 28.h),

                /// Form (Name, Email, Password)
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      // 1. حقل الاسم
                      TextFormField(
                        controller: nameController,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter your name'
                            : null,
                        decoration: InputDecoration(
                          hintText: 'Full Name',
                          prefixIcon: Icon(Icons.person_outline,
                              color: primaryDarkBlue),
                          filled: true,
                          fillColor: Colors.white,
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // 2. حقل الإيميل
                      TextFormField(
                        controller: emailController,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter your email'
                            : null,
                        decoration: InputDecoration(
                          hintText: 'your.email@example.com',
                          prefixIcon: Icon(Icons.email_outlined,
                              color: primaryDarkBlue),
                          filled: true,
                          fillColor: Colors.white,
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // 3. حقل الباسورد
                      TextFormField(
                        controller: passwordController,
                        obscureText: !isPasswordVisible,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter your password'
                            : null,
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          prefixIcon:
                              Icon(Icons.lock_outline, color: primaryDarkBlue),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: primaryDarkBlue,
                            ),
                            onPressed: () => setState(
                              () => isPasswordVisible = !isPasswordVisible,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 32.h),

                /// Sign Up Button
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    if (state is AuthLoading) {
                      return SizedBox(
                        width: double.infinity,
                        height: 52.h,
                        child: Center(
                          child:
                              loading,
                        ),
                      );
                    }
                    return SizedBox(
                      width: double.infinity,
                      height: 52.h,
                      child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            context.read<AuthCubit>().register(
                                  name: nameController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  isEmployer: isEmployerSelected,
                                );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryDarkBlue, // كحلي
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: accentCyan, // لبني
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: 24.h),

                /// Social Media Section
                Row(
                  children: [
                    const Expanded(child: Divider(thickness: 1)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: const Text('Or continue with',
                          style: TextStyle(color: Colors.black54)),
                    ),
                    const Expanded(child: Divider(thickness: 1)),
                  ],
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // زرار جوجل
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: const [
                            BoxShadow(color: Colors.black12, blurRadius: 8),
                          ],
                        ),
                        child: Center(
                          child: SizedBox(
                            height: 28,
                            width: 28,
                            child: Lottie.asset(
                              'assets/icons/Google_Logo.json',
                              repeat: true,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    // زرار لينكد إن
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: const [
                            BoxShadow(color: Colors.black12, blurRadius: 8),
                          ],
                        ),
                        child: Center(
                          child: SizedBox(
                            height: 28,
                            width: 28,
                            child: Transform.scale(
                              scale: 2.8,
                              child: Lottie.asset(
                                'assets/icons/linkdin.json',
                                repeat: true,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),

                SizedBox(height: 32.h),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account? '),
                    GestureDetector(
                      onTap: () {
                        context.go('/login');
                      },
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          color: primaryDarkBlue, // كحلي Bold عشان تبقى متناسقة
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
