import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/picture_utils.dart';
import '../../my.provider/my_auth_provider.dart';
import 'signup_screen.dart';
import 'my_login_screen.dart';


class MyForgotPasswordScreen extends StatefulWidget {
  const MyForgotPasswordScreen({super.key});

  @override
  State<MyForgotPasswordScreen> createState() => _MyForgotPasswordScreenState();
}

class _MyForgotPasswordScreenState extends State<MyForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final forgotProvider = Provider.of<NewAuthProvider>(context);

     return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Make it blend with your background
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Go back to previous screen
          },
        ),
      ),
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image(
              image: userAppBgImageProvider(context),
              fit: BoxFit.cover,
            ),
            forgotProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Text(
                        'Forgot Password',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Email',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          }
                          return null;
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Enter your email',
                          hintStyle: const TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.white30),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.white30),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.amber),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final success = await forgotProvider.forgotPassword(
                                  _emailController.text.trim());

                              final message = forgotProvider.forgotResponse?.message ??
                                  forgotProvider.errorMessage ??
                                  'Something went wrong';

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(message),
                                  backgroundColor: success ? Colors.green : Colors.red,
                                ),
                              );

                              if (success) {
                                await Future.delayed(const Duration(seconds: 3));
                                if (mounted) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (_) => const MyLoginScreen()),
                                  );
                                }
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black54,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(color: Colors.amber),
                            ),
                          ),
                          child: const Text(
                            'Submit',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account? ",
                            style: TextStyle(color: Colors.white70),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => const MySignupScreen()),
                              );
                            },
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                color: Colors.amber,
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
          ],
        ),
      ),
    );
  }
}
