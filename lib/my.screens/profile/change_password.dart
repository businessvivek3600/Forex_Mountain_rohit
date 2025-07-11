import 'package:flutter/material.dart';
import 'package:forex_mountain/widgets/glass_card.dart';
import 'package:forex_mountain/widgets/transparent_container.dart';
import 'package:iconsax/iconsax.dart';
import 'package:forex_mountain/utils/picture_utils.dart'; // For userAppBgImageProvider


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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: const Text("Change Password", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.amber),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [

          Image(
            image: userAppBgImageProvider(context),
            fit: BoxFit.cover,
          ),

          SafeArea(
      
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: TransparentContainer(
                
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      buildPasswordField(
                        label: "Old Password",
                        controller: oldPasswordController,
                        obscureText: isObscuredOld,
                        toggle: () => setState(() => isObscuredOld = !isObscuredOld),
                      ),
                      buildPasswordField(
                        label: "New Password",
                        controller: newPasswordController,
                        obscureText: isObscuredNew,
                        toggle: () => setState(() => isObscuredNew = !isObscuredNew),
                      ),
                      buildPasswordField(
                        label: "Confirm Password",
                        controller: confirmPasswordController,
                        obscureText: isObscuredConfirm,
                        toggle: () => setState(() => isObscuredConfirm = !isObscuredConfirm),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.amber),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () {
                            if (newPasswordController.text != confirmPasswordController.text) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("New and confirm passwords do not match"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            } else {
                              // TODO: Add your logic
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Password Changed"), backgroundColor: Colors.green),
                              );
                            }
                          },
                          child: const Text('Update Password'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
  ]),
        
      );
    
  }

  /// ✅ Password Field Builder
  Widget buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback toggle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            obscureText: obscureText,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Enter $label',
              hintStyle: const TextStyle(color: Colors.white54),
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              suffixIcon: IconButton(
                icon: Icon(obscureText ? Iconsax.eye_slash : Iconsax.eye, color: Colors.white),
                onPressed: toggle,
              ),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            ),
          ),
        ],
      ),
    );
  }
}
