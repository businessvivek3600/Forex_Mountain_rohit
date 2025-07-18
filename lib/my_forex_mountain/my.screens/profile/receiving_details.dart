
import 'package:flutter/material.dart';
import 'custom_image_picker.dart';
import 'package:forex_mountain/utils/picture_utils.dart';
import 'package:forex_mountain/widgets/transparent_text_field.dart';
import 'package:forex_mountain/my_forex_mountain/widgets/transparent_container.dart';


class ReceivingDetails extends StatefulWidget {
  const ReceivingDetails({super.key});

  @override
  State<ReceivingDetails> createState() => _ReceivingDetailsState();
}

class _ReceivingDetailsState extends State<ReceivingDetails> {
  final TextEditingController usdtTrc20Controller = TextEditingController();
  final TextEditingController usdtBep20Controller = TextEditingController();
  final TextEditingController phonePayNumberController = TextEditingController();
  final TextEditingController phonePayIdController = TextEditingController();
  final TextEditingController googlePayNumberController = TextEditingController();
  final TextEditingController googlePayIdController = TextEditingController();
  final TextEditingController bankNameController = TextEditingController();
  final TextEditingController branchNameController = TextEditingController();
  final TextEditingController ifscCodeController = TextEditingController();
  final TextEditingController ibnCodeController = TextEditingController();
  final TextEditingController swiftCodeController = TextEditingController();
  final TextEditingController accountHolderNameController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();

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
                child: Column(
                  children: [
                    // Payment Section
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        buildColumnInput([
                          TransparentTextField(
                            label: "USDT TRC20 Address",
                            hintText: "USDT TRC20 Address",
                            controller: usdtTrc20Controller,
                          ),
                          const SizedBox(height: 12),
                          TransparentTextField(
                            label: "USDT BEP20 Address",
                            hintText: "USDT BEP20 Address",
                            controller: usdtBep20Controller,
                          ),
                        ]),
                        buildColumnInput([
                          TransparentTextField(
                            label: "Phone Pay Number",
                            hintText: "Phone Pay Number",
                            controller: phonePayNumberController,
                          ),
                          const SizedBox(height: 12),
                          TransparentTextField(
                            label: "Phone Pay ID",
                            hintText: "Phone Pay Id",
                            controller: phonePayIdController,
                          ),
                          const SizedBox(height: 12),
                          CustomImagePicker(
                            label: "Phone Pay QR",
                            onImagePicked: (file) {
                              print("Picked PhonePay QR: \${file?.path}");
                            },
                          ),
                        ]),
                        buildColumnInput([
                          TransparentTextField(
                            label: "Google Pay Number",
                            hintText: "Google Pay No.",
                            controller: googlePayNumberController,
                          ),
                          const SizedBox(height: 12),
                          TransparentTextField(
                            label: "Google Pay ID",
                            hintText: "Google Pay ID",
                            controller: googlePayIdController,
                          ),
                          const SizedBox(height: 12),
                          CustomImagePicker(
                            label: "Google Pay QR",
                            onImagePicked: (file) {
                              print("Picked GooglePay QR: \${file?.path}");
                            },
                          ),
                        ]),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Bank Details Section
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        buildBankInput("Bank Name", bankNameController),
                        buildBankInput("Branch Name", branchNameController),
                        buildBankInput("IFSC Code", ifscCodeController),
                        buildBankInput("IBN Code", ibnCodeController),
                        buildBankInput("SWIFT Code", swiftCodeController),
                        buildBankInput("Account Holder Name", accountHolderNameController),
                        buildBankInput("Bank Account No.", accountNumberController,
                            keyboardType: TextInputType.number),
                      ],
                    ),

                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.amber),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          // TODO: Implement submission logic
                        },
                        child: const Text("Update", style: TextStyle(fontSize: 16)),
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

  Widget buildColumnInput(List<Widget> children) {
    double width = MediaQuery.of(context).size.width;
    int itemsPerRow = width > 900 ? 3 : width > 600 ? 2 : 1;

    return SizedBox(
      width: (width - (itemsPerRow - 1) * 16 - 32) / itemsPerRow,
      child: Column(children: children),
    );
  }

  Widget buildBankInput(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    double width = MediaQuery.of(context).size.width;
    int itemsPerRow = width > 900 ? 3 : width > 600 ? 2 : 1;

    return SizedBox(
      width: (width - (itemsPerRow - 1) * 12 - 32) / itemsPerRow,
      child: TransparentTextField(
        label: label,
        controller: controller,
        keyboardType: keyboardType,
      ),
    );
  }
}
