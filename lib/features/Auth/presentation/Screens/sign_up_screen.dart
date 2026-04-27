import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignUpScreen extends StatelessWidget {
  final Function(String email) onEmailChanged;
  final Function(String password) onPasswordChanged;
  final VoidCallback onSignUpPressed;
  final VoidCallback onGooglePressed;
  final VoidCallback onLinkedInPressed;
  final VoidCallback onSignInPressed;

  final bool isEmployerSelected;
  final Function(bool) onUserTypeChanged;

  const SignUpScreen({
    super.key,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    required this.onSignUpPressed,
    required this.onGooglePressed,
    required this.onLinkedInPressed,
    required this.onSignInPressed,
    required this.isEmployerSelected,
    required this.onUserTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
               SizedBox(height: 40.h),

               Text(
                "Create Account",
                style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.bold),
              ),

               SizedBox(height: 8.h),

              const Text("Sign up to get started"),

               SizedBox(height: 30.h),

              /// Toggle Buttons
              Container(
                height: 50.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => onUserTypeChanged(false),
                        child: Container(
                          decoration: BoxDecoration(
                            color: !isEmployerSelected
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Center(child: Text("Job Seeker")),
                        ),
                      ),
                    ),

                    Expanded(
                      child: GestureDetector(
                        onTap: () => onUserTypeChanged(true),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isEmployerSelected
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Center(child: Text("Employer")),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

               SizedBox(height: 30.h),

              /// Email
              TextField(
                onChanged: onEmailChanged,
                decoration: const InputDecoration(
                  hintText: "your.email@example.com",
                  prefixIcon: Icon(Icons.email),
                ),
              ),

               SizedBox(height: 15.h),

              /// Password
              TextField(
                onChanged: onPasswordChanged,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "Enter your password",
                  prefixIcon: Icon(Icons.lock),
                ),
              ),

               SizedBox(height: 25.h),

              /// Sign Up Button
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: onSignUpPressed,
                  child: const Text("Sign Up"),
                ),
              ),

               SizedBox(height: 20.h),

              const Text("Or continue with"),

               SizedBox(height: 15.h),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onGooglePressed,
                      child: const Text("Google"),
                    ),
                  ),

                   SizedBox(width: 10.w),

                  Expanded(
                    child: OutlinedButton(
                      onPressed: onLinkedInPressed,
                      child: const Text("LinkedIn"),
                    ),
                  ),
                ],
              ),

              const Spacer(),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? "),

                  GestureDetector(
                    onTap: onSignInPressed,
                    child: const Text(
                      "Sign In",
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
    );
  }
}
