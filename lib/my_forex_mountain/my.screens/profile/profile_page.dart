import 'package:flutter/material.dart';
import 'package:forex_mountain/my_forex_mountain/widgets/transparent_container.dart';
import 'package:iconsax/iconsax.dart';
import 'change_password.dart';
import 'receiving_details.dart';
import 'verify_KYC.dart';
import 'package:forex_mountain/utils/color.dart';
import 'package:forex_mountain/utils/picture_utils.dart';
import 'package:forex_mountain/utils/text.dart';
import 'package:forex_mountain/my_forex_mountain/widgets/glass_card.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController firstNameController = TextEditingController(text: "YALLAPPA Y");
  final TextEditingController lastNameController = TextEditingController(text: "NAREYAVAR");
  final TextEditingController emailController = TextEditingController(text: "manjuyn5318@gmail.com");
  final TextEditingController mobileController = TextEditingController(text: "9972212183");
  final TextEditingController dobController = TextEditingController(text: "01-01-1417");
  final TextEditingController zipController = TextEditingController(text: "581325");
  final TextEditingController cityController = TextEditingController(text: "DANDELI");
  final TextEditingController houseNoController = TextEditingController(text: "# 158 GANDHI NAGAR DANDELI");
  final TextEditingController address1Controller = TextEditingController(text: "NEAR KANNADA SCHOOL DANDELI");
  final TextEditingController address2Controller = TextEditingController(text: "DANDELI");

  String selectedState = '';
  final List<String> stateList = ['Karnataka', 'Maharashtra', 'Goa', 'Tamil Nadu'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Iconsax.element_4, color: Colors.amber),
          onPressed: () {},
        ),
        title: bodyLargeText('EDIT PROFILE', context, fontSize: 20),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: userAppBgImageProvider(context),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  TransparentContainer(
                    child: Column(
                      children: [
                        buildTextField("Firstname*", firstNameController),
                        buildTextField("Lastname*", lastNameController),
                        buildTextField("Email* Verified Email Address", emailController, readOnly: true),
                        buildPhoneRow(),
                        buildTextField("Date of Birth*", dobController),
                        buildTextField("Zip", zipController),
                        buildTextField("Country", TextEditingController(text: "India"), readOnly: true),
                        buildDropdownField("State", stateList),
                        buildTextField("City", cityController),
                        buildTextField("House/Flat No", houseNoController),
                        buildTextField("Address1", address1Controller),
                        buildTextField("Address 2 (optional)", address2Controller),
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
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Profile Updated")),
                              );
                            },
                            child: const Text('Update Profile'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  buildGlassTile(Iconsax.password_check, "Change Password", () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangePassword()));
                  }),
                  buildGlassTile(Iconsax.message, "Receiving Details", () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ReceivingDetails()));
                  }),
                  buildGlassTile(Iconsax.verify, "Verify KYC", () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const VerifyKyc()));
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildGlassTile(IconData icon, String label, VoidCallback onTap) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            Icon(icon, color: Colors.amber),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const Icon(Iconsax.arrow_right_3, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller, {bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            readOnly: readOnly,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPhoneRow() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Mobile *", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  initialValue: "India (+91)",
                  readOnly: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 3,
                child: TextFormField(
                  controller: mobileController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildDropdownField(String label, List<String> options) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: selectedState.isEmpty ? null : selectedState,
            dropdownColor: Colors.black87,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
            style: const TextStyle(color: Colors.white),
            hint: const Text("Select", style: TextStyle(color: Colors.white70)),
            items: options.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedState = newValue!;
              });
            },
          ),
        ],
      ),
    );
  }
}