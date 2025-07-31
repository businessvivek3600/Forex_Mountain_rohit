import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';


import '../../../utils/picture_utils.dart';
import '../../my.model/login_view_model.dart';
import '../../my.provider/my_auth_provider.dart';
import 'signup_screen.dart';
import 'my_forgot_password_screen.dart';
import '../main_screen.dart';

class MyLoginScreen extends StatefulWidget {
  final String? successMessage;

  const MyLoginScreen({super.key, this.successMessage});

  @override
  State<MyLoginScreen> createState() => _MyLoginScreenState();
}

class _MyLoginScreenState extends State<MyLoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final message = widget.successMessage;
      if (message != null && message.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.green,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: Consumer2<NewAuthProvider, LoginViewModel>(
        builder: (context, authProvider, loginVM, _) {
          return Stack(
            children: [
              _buildBackground(),
              Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                    icon: const Icon(Iconsax.arrow_left, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                body: SafeArea(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Center(
                              child: Text(
                                "LOGIN",
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),
                            const Text("Username", style: TextStyle(color: Colors.white70)),
                            const SizedBox(height: 6),
                            _textField(
                              hint: 'Enter Username',
                              controller: _usernameController,
                              prefixIcon: const Icon(Iconsax.user, color: Colors.white54),
                              validator: (value) =>
                              value == null || value.isEmpty ? 'Username is required' : null,
                            ),
                            const SizedBox(height: 20),
                            const Text("Password", style: TextStyle(color: Colors.white70)),
                            const SizedBox(height: 6),
                            _textField(
                              hint: 'Enter Password',
                              controller: _passwordController,
                              isPassword: true,
                              obscureText: loginVM.obscurePassword,
                              onToggle: loginVM.togglePasswordVisibility,
                              prefixIcon: const Icon(Iconsax.lock, color: Colors.white54),
                              validator: (value) =>
                              value == null || value.isEmpty ? 'Password is required' : null,
                            ),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const MyForgotPasswordScreen()),
                                  );
                                },
                                child: const Text(
                                  'Forgot password?',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            GestureDetector(
                              onTap: authProvider.isLoading
                                  ? null
                                  : () async {
                                if (_formKey.currentState?.validate() ?? false) {
                                  await authProvider.login(
                                    _usernameController.text.trim(),
                                    _passwordController.text.trim(),
                                  );
                                  if (authProvider.customer != null) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (_) => MyMainPage()),
                                    );
                                    Future.delayed(const Duration(milliseconds: 300), () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Login successful'),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    });
                                  } else if (authProvider.errorMessage ==
                                      'Please verify your email before logging in.') {
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: const Text('Email Verification Required'),
                                        content: const Text(
                                          'Your email is not verified. Please check your inbox.',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(),
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    final messenger = ScaffoldMessenger.of(context);
                                    messenger.clearSnackBars();
                                    messenger.showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          authProvider.errorMessage ??
                                              'Invalid username or password',
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor: Colors.red,
                                        behavior: SnackBarBehavior.floating,
                                        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                                        duration: const Duration(seconds: 3),
                                      ),
                                    );
                                  }
                                }
                              },
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF0d0d0d), Color(0xFF8c6d1f)],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      offset: Offset(0, 4),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: const Text(
                                  'Sign in',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),
                            Center(
                              child: RichText(
                                text: TextSpan(
                                  text: "Don't have an account? ",
                                  style: const TextStyle(color: Colors.white70),
                                  children: [
                                    TextSpan(
                                      text: "Register here",
                                      style: const TextStyle(
                                        color: Colors.amber,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(builder: (_) => const MySignupScreen()),
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
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _textField({
    required String hint,
    required TextEditingController controller,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggle,
    FormFieldValidator<String>? validator,
    Widget? prefixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword ? obscureText : false,
        validator: validator,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white54),
          prefixIcon: prefixIcon,
          suffixIcon: isPassword
              ? IconButton(
            icon: Icon(
              obscureText ? Iconsax.eye_slash : Iconsax.eye,
              color: Colors.white54,
            ),
            onPressed: onToggle,
          )
              : null,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        ),
      ),
    );
  }


  Widget _buildBackground() {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: userAppBgImageProvider(context),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Positioned(
        //   top: -80,
        //   left: -80,
        //   child: Container(
        //     height: 250,
        //     width: 250,
        //     decoration: BoxDecoration(
        //       shape: BoxShape.circle,
        //       color: Colors.amber.withOpacity(0.2),
        //     ),
        //   ),
        // ),
        // Positioned(
        //   bottom: -80,
        //   right: -80,
        //   child: Container(
        //     height: 300,
        //     width: 300,
        //     decoration: BoxDecoration(
        //       shape: BoxShape.circle,
        //       color: Colors.white.withOpacity(0.08),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
