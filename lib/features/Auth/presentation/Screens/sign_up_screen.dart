import 'package:flutter/material.dart';

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
              const SizedBox(height: 40),

              const Text(
                "Create Account",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              const Text("Sign up to get started"),

              const SizedBox(height: 30),

              /// Toggle Buttons
              Container(
                height: 50,
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

              const SizedBox(height: 30),

              /// Email
              TextField(
                onChanged: onEmailChanged,
                decoration: const InputDecoration(
                  hintText: "your.email@example.com",
                  prefixIcon: Icon(Icons.email),
                ),
              ),

              const SizedBox(height: 15),

              /// Password
              TextField(
                onChanged: onPasswordChanged,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "Enter your password",
                  prefixIcon: Icon(Icons.lock),
                ),
              ),

              const SizedBox(height: 25),

              /// Sign Up Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: onSignUpPressed,
                  child: const Text("Sign Up"),
                ),
              ),

              const SizedBox(height: 20),

              const Text("Or continue with"),

              const SizedBox(height: 15),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onGooglePressed,
                      child: const Text("Google"),
                    ),
                  ),

                  const SizedBox(width: 10),

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
