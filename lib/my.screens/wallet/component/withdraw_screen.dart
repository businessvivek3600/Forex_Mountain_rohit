import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';

import '../../../utils/color.dart';
import '../../../utils/picture_utils.dart';
import '../../../utils/text.dart';
import '../../../widgets/gradient_custom_button.dart';
import '../../../widgets/transparent_text_field.dart';

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({super.key});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final TextEditingController walletTypeController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController paymentTypeController = TextEditingController();

  final double walletBalance = 474.38;
  final double processingFeePercent = 15;

  String selectedPaymentType = "USDT TRC20";
  final _formKey = GlobalKey<FormState>();

  double get fee => double.tryParse(amountController.text) != null
      ? double.parse(amountController.text) * (processingFeePercent / 100)
      : 0;

  double get netPayable => double.tryParse(amountController.text) != null
      ? double.parse(amountController.text) - fee
      : 0;

  @override
  void initState() {
    super.initState();
    walletTypeController.text = "Maturity";
    paymentTypeController.text = selectedPaymentType;
  }

  @override
  Widget build(BuildContext context) {
    String errorText = selectedPaymentType == "BANK" || selectedPaymentType == "UPI"
        ? "Please review your payment information !!"
        : "Please review your payment information !!\nPlease update your $selectedPaymentType Address";

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: userAppBgImageProvider(context),
          fit: BoxFit.cover,
        ),
      ),
      child:Scaffold(
      backgroundColor:Colors.transparent,
      appBar: AppBar(
        title: bodyLargeText('Withdraw Fund', context, fontSize: 20),
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          bodyLargeText('\$$walletBalance', context, fontSize: 14),
          const SizedBox(width: 16),
        ],
      ),
      body:  SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                      _buildLabel("Select Wallet"),

                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Maturity", style: TextStyle(color: Colors.white70)),

                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  _buildLabel("Amount"),
                  TransparentTextField(
                    controller: amountController,
                    icon: Iconsax.dollar_circle,
                    hintText: "Enter withdrawal amount",
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                    ],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter an amount';
                      }
                      final parsed = double.tryParse(value);
                      if (parsed == null) {
                        return 'Invalid amount';
                      }
                      if (parsed < 10) {
                        return 'Minimum withdrawal is \$10';
                      }
                      if (parsed > walletBalance) {
                        return 'Amount exceeds available balance';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildLabel("Payment Type"),
                  TransparentTextField(
                    icon: Iconsax.wallet_check,
                    controller: paymentTypeController,
                    dropdownItems: const ["USDT TRC20", "USDT BEP20","BANK","UPI"],
                    onChanged: (value) {
                      setState(() {
                        selectedPaymentType = value!;
                      });
                    },
                  ),

                  const SizedBox(height: 12),
                  Text(
                    errorText,
                    style: const TextStyle(color: Colors.redAccent, fontSize: 13),
                  ),
                  if (selectedPaymentType == "BANK") ...[
                    const SizedBox(height: 12),
                    _buildInfoRow("Bank Name:", "865"),
                    _buildInfoRow("Account Holder Name:", "12345678"),
                    _buildInfoRow("Account Number:", "555"),
                    _buildInfoRow("IFSC Code:", "Fgqt"),
                    _buildInfoRow("IBN Code:", "6789"),
                    _buildInfoRow("SWIFT Code:", "sbin0000865"),
                    _buildInfoRow("Branch:", "bhim"),
                  ]
                  else if (selectedPaymentType == "UPI") ...[
                    const SizedBox(height: 12),
                    _buildInfoRow("Google Pay No.:", "8980497056"),
                    _buildInfoRow("Google Pay ID:", "906564346"),
                    const SizedBox(height: 8),
                    const Text("Google Pay QR:", style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 6),
                    SizedBox(
                      height: 150,
                      width: 150,
                      child: Image.network(
                        "https://example.com/qr.png", // Replace with your QR code URL
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Icon(Icons.error, color: Colors.white70),
                      ),
                    ),
                  ],


                  const SizedBox(height: 12),
                   Text(selectedPaymentType, style: TextStyle(color: Colors.white70)),

                  const SizedBox(height: 12),
                  _buildSummaryRow("Processing Fee $processingFeePercent %", fee),
                  const SizedBox(height: 6),
                  _buildSummaryRow("Net Payable", netPayable),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: GradientSaveButton(
          label: "Submit",
          onPressed: () {
            // submit withdraw logic
          },
        ),
      ),
      ),
    );
  }
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          Text(value, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0, left: 4.0),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }

  Widget _buildSummaryRow(String label, double value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13.5)),
        Text("\$${value.toStringAsFixed(2)}",
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
