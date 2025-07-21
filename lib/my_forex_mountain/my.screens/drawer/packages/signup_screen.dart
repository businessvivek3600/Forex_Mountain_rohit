import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:forex_mountain/my_forex_mountain/my.provider/my_auth_provider.dart';
import 'package:forex_mountain/utils/picture_utils.dart';
import 'package:provider/provider.dart';

import '../../my.auth/my_login_screen.dart';

class MySignupScreen extends StatefulWidget {
  const MySignupScreen({super.key});

  @override
  State<MySignupScreen> createState() => _MySignupScreenState();
}

class _MySignupScreenState extends State<MySignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _sponsorController = TextEditingController();
  final TextEditingController _createUsernameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _acceptTerms = false;

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    bool isPassword = false,
    bool enabled = true,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? _obscurePassword : false,
      validator: validator,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
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
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
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

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<NewAuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image(
              image: userAppBgImageProvider(context),
              fit: BoxFit.cover,
            ),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          "REGISTRATION",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
        
                      const Text("Sponsor Username", style: TextStyle(color: Colors.white70)),
                      const SizedBox(height: 6),
                      _textField(
                        controller: _sponsorController,
                        hint: "Sponsor Username",
                        validator: (v) => v == null || v.isEmpty ? 'Sponsor is required' : null,
                      ),
                      const SizedBox(height: 20),
        
                      const Text("Create Username", style: TextStyle(color: Colors.white70)),
                      const SizedBox(height: 6),
                      _textField(
                        controller: _createUsernameController,
                        hint: "Create Username",
                        validator: (v) => v == null || v.isEmpty ? 'Username is required' : null,
                      ),
                      const SizedBox(height: 20),
        
                      const Text("First Name", style: TextStyle(color: Colors.white70)),
                      const SizedBox(height: 6),
                      _textField(
                        controller: _firstNameController,
                        hint: "First Name",
                        validator: (v) => v == null || v.isEmpty ? 'First name is required' : null,
                      ),
                      const SizedBox(height: 20),
        
                      const Text("Last Name", style: TextStyle(color: Colors.white70)),
                      const SizedBox(height: 6),
                      _textField(
                        controller: _lastNameController,
                        hint: "Last Name",
                        validator: (v) => v == null || v.isEmpty ? 'Last name is required' : null,
                      ),
                      const SizedBox(height: 20),
        
                      const Text("Email", style: TextStyle(color: Colors.white70)),
                      const SizedBox(height: 6),
                      _textField(
                        controller: _emailController,
                        hint: "Email",
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Email is required';
                          if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(v)) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
        
                      const Text("Mobile", style: TextStyle(color: Colors.white70)),
                      const SizedBox(height: 6),
                      _textField(
                        controller: _mobileController,
                        hint: "Mobile",
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Mobile is required';
                          if (v.length != 10) return 'Enter valid 10-digit number';
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),
        
                      const Text("Password", style: TextStyle(color: Colors.white70)),
                      const SizedBox(height: 6),
                      const SizedBox(height: 6),
                      _textField(
                        controller: _passwordController,
                        hint: "Password",
                        isPassword: true,
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Password is required';
                          if (v.length < 8) return 'Password must be at least 8 characters';
                          if (!RegExp(r'(?=.*[A-Z])').hasMatch(v)) {
                            return 'Include at least one uppercase letter';
                          }
                          if (!RegExp(r'(?=.*[a-z])').hasMatch(v)) {
                            return 'Include at least one lowercase letter';
                          }
                          if (!RegExp(r'(?=.*\d)').hasMatch(v)) {
                            return 'Include at least one number';
                          }
                          if (!RegExp(r'(?=.*[@$!%*?&])').hasMatch(v)) {
                            return 'Include at least one special character';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
        
                      const Text("Confirm Password", style: TextStyle(color: Colors.white70)),
                      const SizedBox(height: 6),
                      _textField(
                        controller: _confirmPasswordController,
                        hint: "Confirm Password",
                        isPassword: true,
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Confirm password required';
                          if (v != _passwordController.text) return 'Passwords do not match';
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
        
                      Row(
                        children: [
                          Checkbox(
                            value: _acceptTerms,
                            onChanged: (value) => setState(() => _acceptTerms = value ?? false),
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
                                    recognizer: TapGestureRecognizer()..onTap = () {},
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
                            backgroundColor: Colors.amber,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: authProvider.isLoading
                              ? null
                              : () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              if (!_acceptTerms) {
                                _showSnackBar('Please accept terms & conditions', Colors.red);
                                return;
                              }
        
                              await authProvider.signUp(
                                _mobileController.text.trim(),
                                _confirmPasswordController.text.trim(),
                                _emailController.text.trim(),
                                _firstNameController.text.trim(),
                                _lastNameController.text.trim(),
                                _passwordController.text.trim(),
                                _sponsorController.text.trim(),
                                _createUsernameController.text.trim(),
                              );
        
                              if (authProvider.errorMessage != null) {
                                _showSnackBar(authProvider.errorMessage!, Colors.red);
                              } else {
                                _showSnackBar('Signup successful', Colors.green);
                              }
                            }
                          },
                          child: authProvider.isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text('Register',
                              style: TextStyle(color: Colors.white, fontSize: 16)),
                        ),
                      ),
                      const SizedBox(height: 24),
        
                      Center(
                        child: RichText(
                          text: TextSpan(
                            text: "Already have an account? ",
                            style: const TextStyle(color: Colors.white70),
                            children: [
                              TextSpan(
                                text: "Login",
                                style: const TextStyle(
                                  color: Colors.amber,
                                  fontWeight: FontWeight.bold,
                                ),
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
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
