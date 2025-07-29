import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/picture_utils.dart';
import '../../my.provider/my_auth_provider.dart';
import 'my_login_screen.dart';

class MySignupScreen extends StatefulWidget {
  const MySignupScreen({super.key});

  @override
  State<MySignupScreen> createState() => _MySignupScreenState();
}

class _MySignupScreenState extends State<MySignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final _sponsorController = TextEditingController();
  final _createUsernameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _sponsorController.dispose();
    _createUsernameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        elevation: 5,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    Fluttertoast.showToast(
      msg: "Account created successfully. Please verify your email before logging in.",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      backgroundColor: Colors.grey,
      textColor: Colors.black,
      fontSize: 16.0,
    );
    await Future.delayed(const Duration(seconds: 3));
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MyLoginScreen()),
      );
    }
  }

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    bool isPassword = false,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    bool? obscureText,
    VoidCallback? toggleVisibility,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? (obscureText ?? true) : false,
      validator: validator,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.08),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white54),
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(
            (obscureText ?? true) ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
          onPressed: toggleVisibility,
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
    );
  }

  Widget _buildLabelAndField({
    required String label,
    required TextEditingController controller,
    bool isPassword = false,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    bool? obscureText,
    VoidCallback? toggleVisibility,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 6),
          _textField(
            controller: controller,
            hint: label,
            isPassword: isPassword,
            validator: validator,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            obscureText: obscureText,
            toggleVisibility: toggleVisibility,
          ),
        ],
      ),
    );
  }

  Future<void> _launchTermsUrl() async {
    final Uri url = Uri.parse('https://yourdomain.com/terms');
    if (!await launchUrl(url)) {
      _showSnackBar('Could not open Terms and Conditions', Colors.red);
    }
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
            Image(image: userAppBgImageProvider(context), fit: BoxFit.cover),
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
                      _buildLabelAndField(
                        label: "Sponsor Username",
                        controller: _sponsorController,
                        validator: (v) => (v == null || v.isEmpty)
                            ? 'Sponsor Username is required'
                            : null,
                      ),
                      _buildLabelAndField(
                        label: "Create Username",
                        controller: _createUsernameController,
                        validator: (v) => (v == null || v.isEmpty)
                            ? 'Username is required'
                            : null,
                      ),
                      _buildLabelAndField(
                        label: "First Name",
                        controller: _firstNameController,
                        validator: (v) {
                          final name = v?.trim();
                          if (name == null || name.isEmpty) return 'First name is required';
                          if (!RegExp(r'^[A-Za-z ]{2,}$').hasMatch(name)) {
                            return 'Enter a valid first name (letters only)';
                          }
                          return null;
                        },
                      ),
                      _buildLabelAndField(
                        label: "Last Name",
                        controller: _lastNameController,
                        validator: (v) {
                          final name = v?.trim();
                          if (name == null || name.isEmpty) return 'Last name is required';
                          if (!RegExp(r'^[A-Za-z ]{2,}$').hasMatch(name)) {
                            return 'Enter a valid last name (letters only)';
                          }
                          return null;
                        },
                      ),
                      _buildLabelAndField(
                        label: "Email",
                        controller: _emailController,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Email is required';
                          final emailRegex =   RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                          if (!emailRegex.hasMatch(v.trim())) return 'Enter a valid email address';
                          return null;
                        },
                      ),
                      _buildLabelAndField(
                        label: "Mobile",
                        controller: _mobileController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        validator: (v) {
                          final mobile = v?.trim();
                          if (mobile == null || mobile.isEmpty) return 'Mobile number is required';
                          if (mobile.length != 10) return 'Mobile number must be exactly 10 digits';
                          if (!RegExp(r'^[6-9]\d{9}$').hasMatch(mobile)) {
                            return 'Enter a valid Indian mobile number';
                          }
                          return null;
                        },
                      ),
                      _buildLabelAndField(
                        label: "Password",
                        controller: _passwordController,
                        isPassword: true,
                        obscureText: _obscurePassword,
                        toggleVisibility: () {
                          setState(() => _obscurePassword = !_obscurePassword);
                        },
                        validator: (v) {
                          RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                          if (v!.isEmpty) return "Password is required";
                          if (!regex.hasMatch(v)) return "Password must include upper, lower, digit, and special character";
                          return null;
                        },
                      ),
                      _buildLabelAndField(
                        label: "Confirm Password",
                        controller: _confirmPasswordController,
                        isPassword: true,
                        obscureText: _obscureConfirmPassword,
                        toggleVisibility: () {
                          setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                        },
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Confirm password required';
                          if (v != _passwordController.text) return 'Passwords do not match';
                          return null;
                        },
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: _acceptTerms,
                            onChanged: (val) => setState(() => _acceptTerms = val ?? false),
                            activeColor: Colors.yellow,
                            checkColor: Colors.black,
                            side: const BorderSide(color: Colors.white),
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                text: "I accept ",
                                style: const TextStyle(color: Colors.white),

                                children: [
                                  TextSpan(
                                    text: "Terms and Conditions",
                                    style: const TextStyle(
                                      color: Colors.blueAccent,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()..onTap = _launchTermsUrl,
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
                        child: OutlinedButton(
                          onPressed: authProvider.isLoading
                              ? null
                              : () async {
                            if (!_formKey.currentState!.validate()) {
                              _showSnackBar('Fix the form errors', Colors.red);
                              return;
                            }
                            if (!_acceptTerms) {
                              _showSnackBar('Accept Terms & Conditions', Colors.red);
                              return;
                            }
                            final success = await authProvider.signUp(
                              _mobileController.text.trim(),
                              _confirmPasswordController.text.trim(),
                              _emailController.text.trim(),
                              _firstNameController.text.trim(),
                              _lastNameController.text.trim(),
                              _passwordController.text.trim(),
                              _sponsorController.text.trim(),
                              _createUsernameController.text.trim(),
                            );
                            if (!success) {
                              Fluttertoast.showToast(
                                msg: authProvider.errorMessage ?? 'Signup failed. Please try again.',
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );

                            } else {
                              await _showMyDialog();
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.black54,
                            side: const BorderSide(color: Colors.amber),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: authProvider.isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text('Register', style: TextStyle(fontSize: 16)),
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
                                      MaterialPageRoute(
                                        builder: (_) => const MyLoginScreen(),
                                      ),
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
