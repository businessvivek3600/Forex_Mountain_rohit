import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../../../../utils/picture_utils.dart';
import '../../../../utils/text.dart';
import '../../../../widgets/gradient_custom_button.dart';
import '../../../../widgets/transparent_text_field.dart';
import '../../../my.provider/my_wallet_provider.dart';

class TransferToWallet extends StatefulWidget {
  const TransferToWallet({super.key});

  @override
  State<TransferToWallet> createState() => _TransferToWalletState();
}

class _TransferToWalletState extends State<TransferToWallet> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController walletTypeController = TextEditingController();
  late MyWalletProvider walletProvider;
  @override
  void initState() {
    super.initState();
    walletTypeController.text = "wallet_commission";
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    walletProvider = Provider.of<MyWalletProvider>(context);
    final double initialAmount =
        double.tryParse(walletProvider.walletBalance) ?? 0.0;
    amountController.text = initialAmount.toStringAsFixed(2);
  }

  double get netAmount => double.tryParse(amountController.text) ?? 0.0;
  @override
  Widget build(BuildContext context) {
    final double walletBalance =
        double.tryParse(walletProvider.walletBalance) ?? 0.0;
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
            bodyLargeText('\$${walletBalance.toStringAsFixed(2)}', context, fontSize: 14),
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
                        Text("Maturity",
                            style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildLabel("Amount"),
                  TransparentTextField(
                    controller: amountController,
                    icon: Iconsax.dollar_circle,
                    hintText: "Enter transfer amount",
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                    ],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter an amount';
                      }
                      final parsed = double.tryParse(value);
                      if (parsed == null) {
                        return 'Enter a valid number';
                      }
                      if (parsed < 10) {
                        return 'Minimum transfer amount is \$10';
                      }
                      if (parsed > walletBalance) {
                        return 'Amount exceeds your wallet balance';
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
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
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
                final amount = amountController.text.trim();
                final walletType = walletTypeController.text.trim();

                context.read<MyWalletProvider>().transferToTransactionWallet(
                      amount: amount,
                      walletType: walletType,
                      onSuccess: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Transfer successful")),
                        );
                        Navigator.pop(context,true);
                      },
                      onError: (error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(error)),
                        );
                      },
                    );
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
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }
}
