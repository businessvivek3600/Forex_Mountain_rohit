import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:country_picker/country_picker.dart';
import 'package:iconsax/iconsax.dart';
import '../../../screens/dashboard/main_page.dart';
import '../../../utils/picture_utils.dart';
import '../../../utils/text.dart';
import '../../my.provider/my_user_provider.dart';

class VerifyKyc extends StatefulWidget {
  const VerifyKyc({super.key});

  @override
  State<VerifyKyc> createState() => _VerifyKycState();
}

class _VerifyKycState extends State<VerifyKyc> {
  @override
  void initState() {
    Future.microtask(() {
      Provider.of<NewUserProvider>(context, listen: false).getKycData();
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<NewUserProvider>(
      builder: (context, provider, _) {
        if (provider.isLoadingKyc) {
          return const Center(child: CircularProgressIndicator());
        }
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
              surfaceTintColor: Colors.transparent,
              title: bodyLargeText("VERIFY KYC", context, fontSize: 16),
              backgroundColor: Colors.black,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.amber),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UiCategoryTitleContainer(
                      child: Row(
                        children: [
                          Text(
                            provider.isKycApproved
                                ? 'Your KYC Verification is Approved'
                                : provider.isKycRejected
                                ? 'Your KYC Verification is Rejected'
                                : 'Your KYC Verification is Pending',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: provider.isKycApproved
                                  ? Colors.green
                                  : provider.isKycRejected
                                  ? Colors.red
                                  : Colors.amber, // yellow for pending
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            provider.isKycApproved
                                ? Iconsax.tick_circle
                                : provider.isKycRejected
                                ? Iconsax.close_circle
                                : Iconsax.info_circle,
                            color: provider.isKycApproved
                                ? Colors.green
                                : provider.isKycRejected
                                ? Colors.red
                                : Colors.amber,
                            size: 20,
                          ),
                        ],
                      ),

                    ),
                    const SizedBox(height: 20),
                    _buildLabel("Country of Residence"),
                    GestureDetector(
                      onTap: () {
                        provider.isKycApproved
                            ? null
                            : showCountryPicker(
                          context: context,
                          showPhoneCode: false,
                          onSelect: provider.selectCountry,
                        );
                      },
                      child: AbsorbPointer(
                        child: TextFormField(
                          readOnly: true,
                          controller:
                              TextEditingController(text: provider.countryText),
                          style: const TextStyle(color: Colors.white),
                          decoration:
                              _inputDecoration("Select Country", Icons.public),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildLabel("Document Type"),
                    DropdownButtonFormField<String>(
                      value: provider.selectedDocumentType,
                      dropdownColor: Colors.black,
                      iconEnabledColor: Colors.white,
                      decoration: _inputDecoration(
                          "Select Document Type", Icons.description),
                      style: const TextStyle(color: Colors.white),
                      items: provider.documentTypes.map((String type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type,style: TextStyle(color: Colors.white),),
                        );
                      }).toList(),
                      onChanged:provider.isKycApproved ? null :  provider.setDocumentType,
                    ),
                    const SizedBox(height: 16),
                    _buildLabel("Document Number"),
                    TextField(
                      controller: provider.documentNumberController,
                      onChanged: provider.isKycApproved ? null : provider.setDocumentNumber,
                      readOnly: provider.isKycApproved,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration(
                          "Enter Document Number", Icons.badge),
                    ),
                    const SizedBox(height: 20),
                    _buildLabel("Government/Passport Id"),
                    _uploadButton(
                      "Upload Document",
                      Icons.file_upload,
                      () => provider.isKycApproved ? null :showImagePickerBottomSheet(context, false),
                    ),
                    if (provider.documentImage != null)
                      _imagePreview(
                          provider.documentImage!, provider.removeDocumentImage)
                    else if (provider.documentImageUrl != null)
                      _imagePreviewNetwork(provider.documentImageUrl!,
                          provider.removeDocumentImage),
                    const SizedBox(height: 20),
                    _buildLabel("Selfie With Upload Document"),
                    _uploadButton(
                      "Upload Selfie",
                      Icons.camera_alt,
                      () => provider.isKycApproved ? null : showImagePickerBottomSheet(context, true),
                    ),
                    if (provider.selfieImage != null)
                      _imagePreview(
                          provider.selfieImage!, provider.removeSelfieImage)
                    else if (provider.selfieImageUrl != null)
                      _imagePreviewNetwork(
                          provider.selfieImageUrl!, provider.removeSelfieImage),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => provider.submitKyc(
                    onSuccess: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("KYC submitted successfully!"),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.pop(context); // or navigate elsewhere
                    },
                    onError: (errorMessage) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(errorMessage),
                          backgroundColor: Colors.red,
                        ),
                      );
                    },
                  ),
                  icon: const Icon(Iconsax.verify, color: Colors.amber),
                  label: const Text("Submit"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.09),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Colors.amber),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      hintText: label,
      hintStyle: const TextStyle(color: Colors.white70),
      prefixIcon: Icon(icon, color: Colors.white),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  Widget _uploadButton(String text, IconData icon, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white),
        label: Text(text, style: const TextStyle(color: Colors.white)),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.white70),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _imagePreviewNetwork(String imageUrl, VoidCallback onRemove) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(imageUrl,
                height: 120, width: 120, fit: BoxFit.cover),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: InkWell(
              onTap: onRemove,
              child: const Card(
                shape: CircleBorder(),
                color: Colors.black87,
                child: Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Icon(Icons.close, color: Colors.red, size: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _imagePreview(File image, VoidCallback onRemove) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child:
                Image.file(image, height: 120, width: 120, fit: BoxFit.cover),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: InkWell(
              onTap: onRemove,
              child: const Card(
                shape: CircleBorder(),
                color: Colors.black87,
                child: Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Icon(Icons.close, color: Colors.red, size: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, left: 4),
      child: Text(text,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
    );
  }

  void showImagePickerBottomSheet(BuildContext context, bool isSelfie) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () async {
                  Navigator.pop(context);
                  await _handleImagePick(context, isSelfie, ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  await _handleImagePick(
                      context, isSelfie, ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleImagePick(
      BuildContext context, bool isSelfie, ImageSource source) async {
    try {
      await Provider.of<NewUserProvider>(context, listen: false)
          .pickImage(isSelfie: isSelfie, source: source);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }
}
