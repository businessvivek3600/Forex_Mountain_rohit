import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../utils/picture_utils.dart';
import '../../../../utils/text.dart';
import '../../../../widgets/gradient_custom_button.dart';
import '../../../../widgets/transparent_text_field.dart';

class AddFundScreen extends StatefulWidget {
  const AddFundScreen({super.key});

  @override
  State<AddFundScreen> createState() => _AddFundScreenState();
}

class _AddFundScreenState extends State<AddFundScreen> {
  final TextEditingController paymentTypeController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController transactionNumberController = TextEditingController();

  String selectedPaymentType = '';

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
      child:  Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: bodyLargeText('Add Fund', context, fontSize: 20),
          backgroundColor: Colors.black,
          elevation: 0,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20,),
                _buildLabel("Amount"),
                TransparentTextField(
                  controller: amountController,
                  icon: Iconsax.dollar_circle,
                  hintText: "Enter fund amount",
                ),

                const SizedBox(height: 16,),
                _buildLabel("Payment Type"),
                TransparentTextField(
                  controller: paymentTypeController,
                  dropdownItems: const ["USDT", "BANK"],
                  onChanged: (value) {
                    setState(() {
                      selectedPaymentType = value!;
                    });
                  },
                ),

                const SizedBox(height: 10),

                if (selectedPaymentType == "USDT") ...[
                  const Center(
                    child: Text("USDT TRC20", style: TextStyle(color: Colors.white70)),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Image.network("https://as2.ftcdn.net/jpg/05/75/04/69/1000_F_575046954_qW0J1XojpoKKVXsqRBv9EEHxpWbXYXwZ.jpg", height: 180),
                  ),
                ] else if (selectedPaymentType == "BANK") ...[
                  _buildLabel("Bank Details"),
                  const Center(
                    child: Column(
                      children: [
                        Text("Bank Name: BANK OF BARODA", style: TextStyle(color: Colors.white70)),
                        Text("Account No: 83250200001436", style: TextStyle(color: Colors.white70)),
                        Text("IFSC Code: BARB0VJKUMT", style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 16),
                _buildLabel("Upload Payment Proof"),
                Container(
                  width: double.infinity,
                  padding:const EdgeInsets.symmetric(
                      vertical: 16, horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white24),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Text("Choose file", style: TextStyle(color: Colors.white38)),
                ),
                const SizedBox(height: 16,),
                _buildLabel("Transaction Number"),
                TransparentTextField(
                  controller: transactionNumberController,
                  hintText: "Enter transaction number",
                ),
              ],
            ),
          ),
        ),
      bottomNavigationBar:   Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
          child: GradientSaveButton(
            label: "Submit",
            onPressed: () {
              // handle continue logic
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only( bottom: 6.0, left: 4.0),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }
}