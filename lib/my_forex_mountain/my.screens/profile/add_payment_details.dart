import 'dart:io';

import 'package:flutter/material.dart';
import 'package:forex_mountain/my_forex_mountain/my.constant/my_enums.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../../screens/dashboard/main_page.dart';
import '../../../utils/text.dart';
import '../../my.model/my_bank_model.dart';
import '../../my.provider/my_user_provider.dart';
import 'custom_image_picker.dart';
import 'package:forex_mountain/utils/picture_utils.dart';
import 'package:forex_mountain/widgets/transparent_text_field.dart';
import 'package:forex_mountain/my_forex_mountain/widgets/transparent_container.dart';

class AddPaymentDetails extends StatefulWidget {
  final PaymentSection? section;
  final BankDetailsModel? initialData;

  const AddPaymentDetails({super.key, this.section, this.initialData});

  @override
  State<AddPaymentDetails> createState() => _AddPaymentDetailsState();
}

class _AddPaymentDetailsState extends State<AddPaymentDetails> {
  final TextEditingController usdtTrc20Controller = TextEditingController();
  final TextEditingController usdtBep20Controller = TextEditingController();
  final TextEditingController phonePayNumberController =
      TextEditingController();
  final TextEditingController phonePayIdController = TextEditingController();
  final TextEditingController googlePayNumberController =
      TextEditingController();
  final TextEditingController googlePayIdController = TextEditingController();
  final TextEditingController bankNameController = TextEditingController();
  final TextEditingController branchNameController = TextEditingController();
  final TextEditingController ifscCodeController = TextEditingController();
  final TextEditingController ibnCodeController = TextEditingController();
  final TextEditingController swiftCodeController = TextEditingController();
  final TextEditingController accountHolderNameController =
      TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  @override
  void initState() {
    super.initState();

    final data = widget.initialData;

    if (widget.section == PaymentSection.wallet && data != null) {
      usdtTrc20Controller.text = data.usdtTrc?.usdtAddress ?? "";
      usdtBep20Controller.text = data.usdtBep?.obdAddress ?? "";
    }

    if (widget.section == PaymentSection.phonePe && data != null) {
      phonePayNumberController.text = data.phonePay?.phonePayNo ?? "";
      phonePayIdController.text = data.phonePay?.phonePayId ?? "";
      // QR is not loaded here; you'd preload if needed.
    }

    if (widget.section == PaymentSection.googlePay && data != null) {
      googlePayNumberController.text = data.googlePay?.googlePayNo ?? "";
      googlePayIdController.text = data.googlePay?.googlePayId ?? "";
    }

    if (widget.section == PaymentSection.bank && data != null) {
      bankNameController.text = data.bank?.bank ?? "";
      branchNameController.text = data.bank?.branch ?? "";
      accountHolderNameController.text = data.bank?.accountHolderName ?? "";
      accountNumberController.text = data.bank?.accountNumber ?? "";
      ifscCodeController.text = data.bank?.ifscCode ?? "";
      ibnCodeController.text = data.bank?.ibnCode ?? "";
      swiftCodeController.text = data.bank?.swiftCode ?? "";
    }
  }
  File? _phonePayQrFile;
  File? _googlePayQrFile;

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
            title: bodyLargeText("Add Payment Detail", context),
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
                  if (widget.section == PaymentSection.wallet) ...[
                    UiCategoryTitleContainer(
                        child: _buildLabel(
                      'WALLET ADDRESS',
                    )),
                    const SizedBox(height: 10),
                    TransparentTextField(
                      label: "USDT TRC20 Address",
                      hintText: "USDT TRC20 Address",
                      controller: usdtTrc20Controller,
                    ),
                    const SizedBox(height: 16),
                    TransparentTextField(
                      label: "USDT BEP20 Address",
                      hintText: "USDT BEP20 Address",
                      controller: usdtBep20Controller,
                    ),
                    const SizedBox(height: 20),
                  ],

                  if (widget.section == PaymentSection.phonePe) ...[
                    UiCategoryTitleContainer(
                        child: _buildLabel(
                      'PHONE PAY',
                    )),
                    const SizedBox(height: 10),
                    TransparentTextField(
                      label: "Phone Pay Number",
                      hintText: "Phone Pay Number",
                      controller: phonePayNumberController,
                    ),
                    const SizedBox(height: 16),
                    TransparentTextField(
                      label: "Phone Pay ID",
                      hintText: "Phone Pay Id",
                      controller: phonePayIdController,
                    ),
                    const SizedBox(height: 16),
                    CustomImagePicker(
                      label: "Phone Pay QR",
                      onImagePicked: (file) {
                        setState(() {
                          _phonePayQrFile = file;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                  ],

                  if (widget.section == PaymentSection.googlePay) ...[
                    UiCategoryTitleContainer(
                        child: _buildLabel(
                      'GOOGLE PAY',
                    )),
                    const SizedBox(height: 10),
                    TransparentTextField(
                      label: "Google Pay Number",
                      hintText: "Google Pay No.",
                      controller: googlePayNumberController,
                    ),
                    const SizedBox(height: 16),
                    TransparentTextField(
                      label: "Google Pay ID",
                      hintText: "Google Pay ID",
                      controller: googlePayIdController,
                    ),
                    const SizedBox(height: 16),
                    CustomImagePicker(
                      label: "Google Pay QR",
                      onImagePicked: (file) {
                        setState(() {
                          _googlePayQrFile = file;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                  ],


                  // Bank Details Section
                  if (widget.section == PaymentSection.bank) ...[
                    UiCategoryTitleContainer(
                      child: _buildLabel('BANK DETAILS'),
                    ),
                    const SizedBox(height: 10),
                    buildBankInput("Bank Name", bankNameController),
                    const SizedBox(height: 16),
                    buildBankInput("Branch Name", branchNameController),
                    const SizedBox(height: 16),
                    buildBankInput("Account Holder Name", accountHolderNameController),
                    const SizedBox(height: 16),
                    buildBankInput("Bank Account No.", accountNumberController,
                        keyboardType: TextInputType.number),
                    const SizedBox(height: 16),
                    buildBankInput("SWIFT Code", swiftCodeController),
                    const SizedBox(height: 16),
                    buildBankInput("IFSC Code", ifscCodeController),
                    const SizedBox(height: 8),

                    /// 👇 Hint for optional field
                    const Text(
                      "IBN Code is optional",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 8),

                    buildBankInput("IBN Code", ibnCodeController),
                    const SizedBox(height: 32),
                  ],

                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
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
                  onPressed: () {
                    final provider = Provider.of<NewUserProvider>(context, listen: false);

                    // --- Validation ---
                    if (widget.section == PaymentSection.wallet) {
                      if (usdtTrc20Controller.text.trim().isEmpty &&
                          usdtBep20Controller.text.trim().isEmpty) {
                        _showError("Please enter at least one wallet address (TRC20 or BEP20)");
                        return;
                      }
                    }

                    if (widget.section == PaymentSection.phonePe) {
                      if (phonePayNumberController.text.trim().isEmpty &&
                          phonePayIdController.text.trim().isEmpty) {
                        _showError("Please enter Phone Pay Number or ID");
                        return;
                      }
                    }

                    if (widget.section == PaymentSection.googlePay) {
                      if (googlePayNumberController.text.trim().isEmpty &&
                          googlePayIdController.text.trim().isEmpty) {
                        _showError("Please enter Google Pay Number or ID");
                        return;
                      }
                    }

                    if (widget.section == PaymentSection.bank) {
                      if (bankNameController.text.trim().isEmpty ||
                          ifscCodeController.text.trim().isEmpty ||
                          accountHolderNameController.text.trim().isEmpty ||
                          accountNumberController.text.trim().isEmpty) {
                        _showError("Please fill all required bank fields (Bank Name, IFSC, Account Holder Name, Account Number)");
                        return;
                      }
                    }

                    // --- Build BankDetailsModel ---
                    final bankDetails = BankDetailsModel(
                      bank: widget.section == PaymentSection.bank
                          ? BankModel(
                        bank: bankNameController.text.trim(),
                        branch: branchNameController.text.trim(),
                        ifscCode: ifscCodeController.text.trim(),
                        ibnCode: ibnCodeController.text.trim(),
                        swiftCode: swiftCodeController.text.trim(),
                        accountHolderName: accountHolderNameController.text.trim(),
                        accountNumber: accountNumberController.text.trim(),
                      )
                          : widget.initialData?.bank,
                      usdtTrc: widget.section == PaymentSection.wallet &&
                          usdtTrc20Controller.text.trim().isNotEmpty
                          ? UsdtTrcModel(usdtAddress: usdtTrc20Controller.text.trim())
                          : widget.initialData?.usdtTrc,
                      usdtBep: widget.section == PaymentSection.wallet &&
                          usdtBep20Controller.text.trim().isNotEmpty
                          ? UsdtBepModel(obdAddress: usdtBep20Controller.text.trim())
                          : widget.initialData?.usdtBep,
                      phonePay: widget.section == PaymentSection.phonePe
                          ? PhonePayModel(
                        phonePayNo: phonePayNumberController.text.trim(),
                        phonePayId: phonePayIdController.text.trim(),
                      )
                          : widget.initialData?.phonePay,
                      googlePay: widget.section == PaymentSection.googlePay
                          ? GooglePayModel(
                        googlePayNo: googlePayNumberController.text.trim(),
                        googlePayId: googlePayIdController.text.trim(),
                      )
                          : widget.initialData?.googlePay,
                    );

                    // --- Submit to provider ---
                    provider.addBankDetails(
                      bankDetails: bankDetails,
                      phonePayQrImage:
                      widget.section == PaymentSection.phonePe ? _phonePayQrFile : null,
                      googlePayQrImage:
                      widget.section == PaymentSection.googlePay ? _googlePayQrFile : null,
                      context: context,
                    );
                  }



              ),
            ),
          )),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(text,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16));
  }

  Widget buildColumnInput(List<Widget> children) {
    double width = MediaQuery.of(context).size.width;
    int itemsPerRow = width > 900
        ? 3
        : width > 600
            ? 2
            : 1;

    return SizedBox(
      width: (width - (itemsPerRow - 1) * 16 - 32) / itemsPerRow,
      child: Column(children: children),
    );
  }

  Widget buildBankInput(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    double width = MediaQuery.of(context).size.width;
    int itemsPerRow = width > 900
        ? 3
        : width > 600
            ? 2
            : 1;

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
