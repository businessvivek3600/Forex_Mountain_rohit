import 'package:flutter/material.dart';
import 'package:forex_mountain/widgets/transparent_container.dart';
import 'package:iconsax/iconsax.dart';
import 'package:forex_mountain/widgets/glass_card.dart';
import 'package:forex_mountain/utils/picture_utils.dart'; // For userAppBgImageProvider()

class VerifyKyc extends StatefulWidget {
  const VerifyKyc({super.key});

  @override
  State<VerifyKyc> createState() => _VerifyKycState();
}

class _VerifyKycState extends State<VerifyKyc> {
  final List<String> _countries = ['India', 'USA', 'UK', 'Canada', 'Germany'];
  final List<String> _documentTypes = ['Select', 'Passport', 'Government ID'];

  String _selectedCountry = 'India';
  String _selectedDocumentType = 'Select';
  final TextEditingController _documentNumberController =
      TextEditingController();

  @override
  void dispose() {
    _documentNumberController.dispose();
    super.dispose();
  }

  void _uploadDocument() {
    // TODO: Implement file picker for document
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Upload Document tapped")),
    );
  }

  void _uploadSelfie() {
    // TODO: Implement file picker for selfie
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Upload Selfie tapped")),
    );
  }

  void _submitKyc() {
    if (_selectedCountry.isEmpty ||
        _selectedDocumentType == 'Select' ||
        _documentNumberController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete all fields")),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("KYC Submitted")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: const Text("Verify KYC", style: TextStyle(color: Colors.white)),
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
                    const Text(
                      "Complete Your KYC",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Country Dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedCountry,
                      dropdownColor: Colors.black,
                      iconEnabledColor: Colors.white,
                      decoration: InputDecoration(
                        labelText: 'Country',
                        labelStyle: const TextStyle(color: Colors.white70),
                        prefixIcon:
                            const Icon(Icons.public, color: Colors.white),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      style: const TextStyle(color: Colors.white),
                      items: _countries.map((String country) {
                        return DropdownMenuItem<String>(
                          value: country,
                          child: Text(country),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCountry = newValue!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Document Type Dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedDocumentType,
                      dropdownColor: Colors.black,
                      iconEnabledColor: Colors.white,
                      decoration: InputDecoration(
                        labelText: 'Document Type',
                        labelStyle: const TextStyle(color: Colors.white70),
                        prefixIcon:
                            const Icon(Icons.description, color: Colors.white),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      style: const TextStyle(color: Colors.white),
                      items: _documentTypes.map((String type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedDocumentType = newValue!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Document Number Field
                    TextField(
                      controller: _documentNumberController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Document Number',
                        labelStyle: const TextStyle(color: Colors.white70),
                        prefixIcon:
                            const Icon(Icons.badge, color: Colors.white),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Upload Document
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _uploadDocument,
                        icon:
                            const Icon(Icons.file_upload, color: Colors.white),
                        label: const Text("Upload Document",
                            style: TextStyle(color: Colors.white)),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white70),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Upload Selfie
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _uploadSelfie,
                        icon: const Icon(Icons.camera_alt, color: Colors.white),
                        label: const Text("Upload Selfie",
                            style: TextStyle(color: Colors.white)),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white70),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _submitKyc,
                        icon: const Icon(
                          Iconsax.verify,
                          color: Colors.amber,
                        ),
                        label: const Text("Submit"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.2),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: Colors.amber),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
