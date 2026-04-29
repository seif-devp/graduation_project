import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_project/features/Auth/presentation/controller/auth_cubit.dart';
import 'package:lottie/lottie.dart';

class SignInScreen extends StatefulWidget {
  final bool initialEmployerSelected;

  const SignInScreen({super.key, this.initialEmployerSelected = false});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late bool isEmployerSelected;
  bool isPasswordVisible = false;
  String email = '';
  String password = '';
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // ألوان الهوية البصرية عشان نستخدمها بسهولة
  final Color primaryDarkBlue = const Color.fromARGB(255, 3, 59, 122);
  final Color accentCyan = const Color(0xFF00F2FE);

  @override
  void initState() {
    super.initState();
    isEmployerSelected = widget.initialEmployerSelected;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Signing in...')),
          );
        }
        if (state is AuthSuccess) {
          if (isEmployerSelected) {
            context.goNamed('home_employer', extra: {'isEmployer': true});
          } else {
            context.goNamed('home', extra: {'isEmployer': false});
          }
        }
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error occurred while signing in')),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FF), // خلفية فاتحة ومريحة
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 32.h),
                Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.bold,
                    color: primaryDarkBlue, // تطعيم بالكحلي
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Sign in to continue',
                  style: TextStyle(fontSize: 16.sp, color: Colors.black54),
                ),
                SizedBox(height: 32.h),
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
                                  ? primaryDarkBlue
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
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter your email'
                            : null,
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: 'your.email@example.com',
                          prefixIcon: Icon(Icons.email_outlined,
                              color: primaryDarkBlue), // آيكون كحلي
                          filled: true,
                          fillColor: Colors.white,
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      TextFormField(
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter your password'
                            : null,
                        controller: passwordController,
                        obscureText: !isPasswordVisible,
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          prefixIcon: Icon(Icons.lock_outline,
                              color: primaryDarkBlue), // آيكون كحلي
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
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                          color: primaryDarkBlue, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    if (state is AuthLoading) {
                      return SizedBox(
                        width: double.infinity.w,
                        height: 52.h,
                        child: Center(
                          child:
                              CircularProgressIndicator(color: primaryDarkBlue),
                        ),
                      );
                    }
                    return SizedBox(
                      width: double.infinity.w,
                      height: 52.h,
                      child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            context.read<AuthCubit>().login(
                                  email: emailController.text,
                                  password: passwordController.text,
                                  isEmployer: isEmployerSelected,
                                );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryDarkBlue, // الزرار كحلي
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            color: accentCyan, // الكتابة لبني زي السبلاش
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 24.h),
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
                    // زرار جوجل بعد التعديل
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 50.h,
                        width: 50.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: const [
                            BoxShadow(color: Colors.black12, blurRadius: 8),
                          ],
                        ),
                        child: Center(
                          child: SizedBox(
                            height: 28.h,
                            width: 28.w,
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
                    // زرار لينكد إن بعد التعديل
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 50.h,
                        width: 50.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: const [
                            BoxShadow(color: Colors.black12, blurRadius: 8),
                          ],
                        ),
                        child: Center(
                          child: SizedBox(
                            height: 28.h,
                            width: 28.w,
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
                    const Text('Don\'t have an account? '),
                    GestureDetector(
                      onTap: () {
                        context.go('/startup',
                            extra: {'isEmployer': isEmployerSelected});
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: primaryDarkBlue, // كحلي Bold
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
