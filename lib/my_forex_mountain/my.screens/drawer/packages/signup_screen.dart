import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../screens/dashboard/main_page.dart';
import 'package:forex_mountain/utils/color.dart';
import '../../my.auth/my_login_screen.dart';

import '../../my.auth/login_screen.dart';

class MySignupScreen extends StatefulWidget {
  const MySignupScreen({super.key});

  @override
  State<MySignupScreen> createState() => _MySignupScreenState();
}

class _MySignupScreenState extends State<MySignupScreen> {
  final TextEditingController _sponsorController = TextEditingController();
  final TextEditingController _createUsernameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _acceptTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Text(
                  "REGISTRATION",
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),

                _textField(
                  controller: _sponsorController,
                  hint: "Sponsor Username",
                  validator: (value) => value == null || value.isEmpty ? 'Sponsor Username is required' : null,
                ),
                const SizedBox(height: 16),

                _textField(
                  controller: _createUsernameController,
                  hint: "Create Username",
                  validator: (value) => value == null || value.isEmpty ? 'Username is required' : null,
                ),
                const SizedBox(height: 16),

                _textField(
                  controller: _firstNameController,
                  hint: "First Name",
                  validator: (value) => value == null || value.isEmpty ? 'First Name is required' : null,
                ),
                const SizedBox(height: 16),

                _textField(
                  controller: _lastNameController,
                  hint: "Last Name",
                  validator: (value) => value == null || value.isEmpty ? 'Last Name is required' : null,
                ),
                const SizedBox(height: 16),

                _textField(
                  controller: _emailController,
                  hint: "Email",
                  validator: (value) => value == null || value.isEmpty ? 'Email is required' : null,
                ),
                const SizedBox(height: 16),

                _textField(
                  controller: _mobileController,
                  hint: "Mobile",
                  validator: (value) => value == null || value.isEmpty ? 'Mobile is required' : null,
                ),
                const SizedBox(height: 16),

                _textField(
                  controller: _passwordController,
                  hint: "Password",
                  isPassword: true,
                  validator: (value) => value == null || value.isEmpty ? 'Password is required' : null,
                ),
                const SizedBox(height: 16),

                _textField(
                  controller: _confirmPasswordController,
                  hint: "Confirm Password",
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Confirm Password is required';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    Checkbox(
                      value: _acceptTerms,
                      onChanged: (value) {
                        setState(() => _acceptTerms = value ?? false);
                      },
                      activeColor: Colors.yellow,
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          text: "I accept ",
                          style: const TextStyle(color: Colors.white),
                          children: [
                            TextSpan(
                              text: "Terms and Conditions",
                              style: const TextStyle(color: Colors.blueAccent),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // Handle terms tap
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) return;

                      if (!_acceptTerms) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please accept terms & conditions')),
                        );
                        return;
                      }

                      setState(() => _isLoading = true);
                      Future.delayed(const Duration(seconds: 2), () {
                        setState(() => _isLoading = false);
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MainPage()));
                      });
                    },
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      'Register',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                RichText(
                  text: TextSpan(
                    text: "Already have an account? ",
                    style: const TextStyle(color: Colors.white70),
                    children: [
                      TextSpan(
                        text: "Login",
                        style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => const MyLoginScreen()),
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    bool isPassword = false,
    bool enabled = true,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      obscureText: isPassword ? _obscurePassword : false,
      validator: validator,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.08),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white54),
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
          onPressed: enabled
              ? () => setState(() => _obscurePassword = !_obscurePassword)
              : null,
        )
            : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white30),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white54),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}
