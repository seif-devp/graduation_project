import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_project/features/Auth/presentation/controller/auth_cubit.dart';

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
          context.go('/home');
        }
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error occurred while signing in')),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FF),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 SizedBox(height: 32.h),
                 Text(
                  'Welcome Back',
                  style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold),
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
                                  ? Colors.white
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(26),
                            ),
                            child: const Center(child: Text('Job Seeker')),
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
                                  ? Colors.white
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(26),
                            ),
                            child: const Center(child: Text('Employer')),
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
                        decoration: const InputDecoration(
                          hintText: 'your.email@example.com',
                          prefixIcon: Icon(Icons.email_outlined),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
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
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
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
                    child: const Text('Forgot Password?'),
                  ),
                ),
                 SizedBox(height: 20.h),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    if (state is AuthLoading) {
                      return  SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    return SizedBox(
                      width: double.infinity,
                      height: 52.h,
                      child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            // Perform sign in logic here
                            context.read<AuthCubit>().login(
                              email: emailController.text,
                              password: passwordController.text,
                              isEmployer: isEmployerSelected,
                            );
                          }
                        },

                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text('Sign In'),
                      ),
                    );
                  },
                ),
                 SizedBox(height: 24.h),
                Row(
                  children:  [
                    Expanded(child: Divider(thickness: 1)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Text('Or continue with'),
                    ),
                    Expanded(child: Divider(thickness: 1)),
                  ],
                ),
                 SizedBox(height: 20.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text('Google'),
                      ),
                    ),
                     SizedBox(width: 12.h),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text('LinkedIn'),
                      ),
                    ),
                  ],
                ),
                 SizedBox(height: 32.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Don\'t have an account? '),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.blue,
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
