import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/picture_utils.dart';
import '../../../../utils/text.dart';
import '../../../../widgets/gradient_custom_button.dart';
import '../../../../widgets/transparent_text_field.dart';

class TransferToWallet extends StatefulWidget {
  const TransferToWallet({super.key});

  @override
  State<TransferToWallet> createState() => _TransferToWalletState();
}

class _TransferToWalletState extends State<TransferToWallet> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController amountController = TextEditingController();
  final double walletBalance = 474.38;
final TextEditingController walletTypeController = TextEditingController();
  double get netAmount => double.tryParse(amountController.text) ?? 0;

  @override
  void initState() {
    super.initState();
    walletTypeController.text = "Maturity";
    amountController.text = walletBalance.toStringAsFixed(2);

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
          title: bodyLargeText('Transfer Wallet', context, fontSize: 20),
          backgroundColor: Colors.black,
          elevation: 0,
          actions: [
            bodyLargeText('\$$walletBalance', context, fontSize: 14),
            const SizedBox(width: 16),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildLabel("Receiving Wallet"),
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
                    hintText: "Enter transfer amount",
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                    ],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter an amount';
                      }
                      final parsed = double.tryParse(value);
                      if (parsed == null || parsed <= 0) {
                        return 'Enter a valid amount';
                      }
                      if (parsed > walletBalance) {
                        return 'Amount exceeds available balance';
                      }
                      return null;
                    },
                    onChanged: (_) => setState(() {}),
                  ),


                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildLabel("Net Amount"),
                      Text(
                        "\$${amountController.text}",
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
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
              if (_formKey.currentState!.validate()) {
                // TODO: Submit transfer logic here
                print("Transferring \$${netAmount.toStringAsFixed(2)}");
              }
            },
          ),
        ),
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
}

