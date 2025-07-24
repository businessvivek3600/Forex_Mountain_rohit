import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:forex_mountain/my_forex_mountain/my.model/my_customer_model.dart';

import 'package:forex_mountain/utils/picture_utils.dart';
import 'package:forex_mountain/utils/text.dart';
import 'package:provider/provider.dart';

import '../../my.provider/my_dashboard_provider.dart';
import '../../my.provider/my_user_provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, this.customer});
  final MyCustomerModel? customer;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController zipController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController houseNoController = TextEditingController();
  final TextEditingController address1Controller = TextEditingController();
  final TextEditingController address2Controller = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  String selectedCountryCode = '';
  String selectedCountryName = '';
  Country? selectedCountry;
  bool isKycVerified = false;
  bool isEmailVerified = false;

  @override
  void initState() {
    super.initState();
    final c = widget.customer;

    if (c != null) {
      firstNameController.text = c.firstName ?? '';
      lastNameController.text = c.lastName ?? '';
      emailController.text = c.customerEmail ?? '';
      mobileController.text = c.customerMobile ?? '';
      dobController.text = c.dateOfBirth ?? '';
      zipController.text = c.zip ?? '';
      cityController.text = c.city ?? '';
      houseNoController.text = c.customerShortAddress ?? '';
      address1Controller.text = c.customerAddress1 ?? '';
      address2Controller.text = c.customerAddress2 ?? '';
      stateController.text = c.state ?? '';
      selectedCountryName = c.countryText ?? '';
      selectedCountryCode = c.country ?? ''; // ✅ Store raw country ID for backend
      countryController.text = selectedCountryName;

      // Safely convert countryText to country name using tryParse
      try {
        final parsedCountry = Country.tryParse(selectedCountryName);
        if (parsedCountry != null) {
          selectedCountryName = parsedCountry.name;
          countryController.text = selectedCountryName;
        } else {
          selectedCountryName = '';
          countryController.text = '';
          debugPrint("⚠️ Invalid country code: ${c.countryText}");
        }
      } catch (e) {
        selectedCountryName = '';
        countryController.text = '';
        debugPrint("❌ Country parse error: $e");
      }

      isKycVerified = (c.kyc?.toString() == '1');         // ✅ Null-safe
      isEmailVerified = (c.verifyEmail?.toString() == '1'); // ✅ Null-safe
    } else {
      debugPrint("⚠️ Customer model is null");
    }
  }
  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: userAppBgImageProvider(context),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: bodyLargeText('EDIT PROFILE', context, fontSize: 20),
          backgroundColor: Colors.black,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.amber),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    buildTextField("Firstname", firstNameController,readOnly: isKycVerified),
                    buildTextField("Lastname", lastNameController,readOnly: isKycVerified),
                    if (isKycVerified)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.green.shade700.withOpacity(0.2),
                            border: Border.all(color: Colors.green.shade400),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.check_circle_outline, color: Colors.green, size: 20),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "Your KYC is verified. Name changes are not allowed.",
                                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                   if(!isEmailVerified) buildTextField(
                        "Email Verified Email Address", emailController, validator: (value) {
                     if (value == null || value.isEmpty) return "Email is required";
                     final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
                     if (!emailRegex.hasMatch(value)) return "Enter a valid email";
                     return null;
                   },),
                    buildTextField(
                      "Mobile N.",
                      mobileController,keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) return "Mobile number is required";
                        final phoneRegex = RegExp(r'^\d{7,15}$');
                        if (!phoneRegex.hasMatch(value)) return "Enter valid 7–15 digit number";
                        return null;
                      },
                    ),
                    buildDatePickerField("Date of Birth", dobController),
                    buildTextField("Zip", zipController),
                    buildCountryPickerField(),
                    buildTextField("State", stateController),
                    buildTextField("City", cityController),
                    buildTextField("House/Flat No", houseNoController),
                    buildTextField("Address1", address1Controller),
                    buildTextField("Address 2 (optional)", address2Controller),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                final firstName = firstNameController.text.trim();
                final email = emailController.text.trim();
                final mobile = mobileController.text.trim();

                if (firstName.isEmpty || email.isEmpty || mobile.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          "⚠️ First name, email, and mobile are required."),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                Provider.of<NewUserProvider>(context, listen: false)
                    .updateUserProfile(
                  firstName: firstName,
                  lastName: lastNameController.text.trim(),
                  dateOfBirth: dobController.text.trim(),
                  state: stateController.text.trim(),
                  city: cityController.text.trim(),
                  customerShortAddress: houseNoController.text.trim(),
                  customerAddress1: address1Controller.text.trim(),
                  customerAddress2: address2Controller.text.trim(),
                  zip: zipController.text.trim(),
                  country: selectedCountryCode,
                  customerMobile: mobileController.text.trim(),
                  context: context,
                )
                    .then((success) {
                  if (success == true) {
                    // ✅ Call dashboard API to refresh data
                    Provider.of<MyDashboardProvider>(context, listen: false)
                        .getDashboardData();

                    // ✅ Navigate back to Profile Page
                    Navigator.pop(context, true);
                  }
                });
              },
              label: const Text(
                "Update",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.09),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Colors.amber, width: 0.6),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDatePickerField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: () async {
              DateTime initialDate;
              try {
                initialDate = DateTime.parse(controller.text);
              } catch (_) {
                initialDate = DateTime.now();
              }

              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: initialDate,
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.dark(
                        primary: Colors.amber,
                        onPrimary: Colors.black,
                        surface: Colors.black,
                        onSurface: Colors.white,
                      ),
                      dialogBackgroundColor: Colors.grey[900],
                    ),
                    child: child!,
                  );
                },
              );

              if (pickedDate != null) {
                controller.text = pickedDate.toIso8601String().split("T").first;
              }
            },
            child: AbsorbPointer(
              child: TextFormField(
                controller: controller,
                readOnly: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller,
      {bool readOnly = false, String? Function(String?)? validator, TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            readOnly: readOnly,
            style: const TextStyle(color: Colors.white),
            keyboardType: keyboardType,
            validator: validator,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            ),
          ),
        ],
      ),
    );
  }


  Widget buildCountryPickerField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Country",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: () {
              showCountryPicker(
                context: context,
                showPhoneCode: true,
                onSelect: (Country country) {
                  setState(() {
                    selectedCountryCode = country.countryCode; // for backend
                    selectedCountryName = country.name; // for display
                    countryController.text = selectedCountryName;
                  });
                },
              );
            },
            child: AbsorbPointer(
              child: TextFormField(
                controller: countryController,
                readOnly: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
