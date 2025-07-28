import 'package:flutter/material.dart';
import 'package:forex_mountain/my_forex_mountain/widgets/glass_card.dart';
import 'package:iconsax/iconsax.dart';
import 'package:forex_mountain/utils/picture_utils.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../utils/text.dart';
import '../../my.provider/my_user_provider.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool isObscuredOld = true;
  bool isObscuredNew = true;
  bool isObscuredConfirm = true;



  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: userAppBgImageProvider(context),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: bodyLargeText("Change Password", context),
          backgroundColor: Colors.black,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.amber),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child:  _buildPasswordForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const GlassCard(
          padding: EdgeInsets.all(14),
          child: Row(
            children: [
              Icon(Iconsax.lock, color: Colors.amber, size: 20),
              SizedBox(width: 8),
              Text(
                'Update your password securely',
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _buildLabel("Old Password"),
        _buildPasswordField(
          controller: oldPasswordController,
          obscureText: isObscuredOld,
          toggle: () => setState(() => isObscuredOld = !isObscuredOld),
          hint: "Enter your old password",
        ),
        const SizedBox(height: 16),
        _buildLabel("New Password"),
        _buildPasswordField(
          controller: newPasswordController,
          obscureText: isObscuredNew,
          toggle: () => setState(() => isObscuredNew = !isObscuredNew),
          hint: "Enter your new password",
        ),
        const SizedBox(height: 16),
        _buildLabel("Confirm New Password"),
        _buildPasswordField(
          controller: confirmPasswordController,
          obscureText: isObscuredConfirm,
          toggle: () => setState(() => isObscuredConfirm = !isObscuredConfirm),
          hint: "Re-enter your new password",
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.amber),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: _handleChangePassword,
            child: const Text('Update Password'),
          ),
        ),
      ],
    );
  }

  void _handleChangePassword() {
    final oldPassword = oldPasswordController.text.trim();
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("New and confirm passwords do not match"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final provider = Provider.of<NewUserProvider>(context, listen: false);
    provider.changeUserPassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
      context: context,
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 13.5,
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback toggle,
    required String hint,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Iconsax.eye_slash : Iconsax.eye,
            color: Colors.white,
          ),
          onPressed: toggle,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      ),
    );
  }
}

