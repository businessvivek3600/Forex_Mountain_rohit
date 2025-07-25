import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forex_mountain/my_forex_mountain/my.provider/my_wallet_provider.dart';
import 'package:forex_mountain/my_forex_mountain/my.screens/support/support_screen.dart';
import 'package:forex_mountain/my_forex_mountain/widgets/transparent_container.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../../../../utils/color.dart';
import '../../../../utils/picture_utils.dart';
import '../../../../utils/text.dart';
import '../../../../widgets/gradient_custom_button.dart';
import '../../../../widgets/transparent_text_field.dart';
import '../../../my.model/my_bank_model.dart';
import '../../../my.provider/my_dashboard_provider.dart';

// Imports remain the same

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({super.key});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final walletTypeController = TextEditingController();
  final amountController = TextEditingController();
  final paymentTypeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  final dropdownDisplayList = [
    "USDT TRC20",
    "USDT BEP20",
    "BANK",
    "Google Pay",
    "Phone Pay"
  ];

  @override
  void initState() {
    super.initState();
    walletTypeController.text = "Maturity";

    final walletProvider = Provider.of<MyWalletProvider>(context, listen: false);
    final defaultPaymentType = walletProvider.selectedPaymentType.isNotEmpty
        ? walletProvider.selectedPaymentType
        : "BANK";

    paymentTypeController.text = defaultPaymentType;
    amountController.text = double.tryParse(walletProvider.walletBalance)?.toStringAsFixed(2) ?? '';

    amountController.addListener(() => _updateFees(context));
  }

  void _updateFees(BuildContext context) {
    final walletProvider = Provider.of<MyWalletProvider>(context, listen: false);
    final dashboardProvider = Provider.of<MyDashboardProvider>(context, listen: false);

    final amount = double.tryParse(amountController.text) ?? 0.0;
    final percent = double.tryParse(dashboardProvider.companyInfo?.adminCharge ?? "0") ?? 0.0;

    final fees = (amount * percent) / 100;
    final net = amount - fees;

    walletProvider.setProcessingFees(fees);
    walletProvider.setNetPayable(net);
  }

  @override
  Widget build(BuildContext context) {
    final dashboardProvider = Provider.of<MyDashboardProvider>(context);
    final walletProvider = Provider.of<MyWalletProvider>(context);
    final bank = dashboardProvider.bankDetails;

    final selectedPaymentType = walletProvider.selectedPaymentType.isNotEmpty
        ? walletProvider.selectedPaymentType
        : "BANK";

    final errorText = "Please review your payment information !!\n"
        "Please update your $selectedPaymentType Address";

    final minWithdraw = double.tryParse(dashboardProvider.companyInfo?.minimumWithdraw ?? '10') ?? 10;
    final balance = double.tryParse(walletProvider.walletBalance ?? '0') ?? 0;

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
          title: bodyLargeText('Withdraw Fund', context, fontSize: 20),
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.amber),
          elevation: 0,
          actions: [
            bodyLargeText(
              '\$${balance.toStringAsFixed(2)}',
              context,
              fontSize: 14,
            ),
            const SizedBox(width: 16),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildLabel("Select Wallet"),
                  _buildReadOnlyField("Maturity"),

                  const SizedBox(height: 16),
                  _buildLabel("Amount"),
                  TransparentTextField(
                    controller: amountController,
                    icon: Iconsax.dollar_circle,
                    hintText: "Enter withdrawal amount",
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
                    validator: (value) {
                      final parsed = double.tryParse(value ?? '');
                      if (value == null || value.trim().isEmpty) return 'Please enter an amount';
                      if (parsed == null) return 'Invalid amount';
                      if (parsed < minWithdraw) return 'Minimum withdrawal is \$${minWithdraw.toInt()}';
                      if (parsed > balance) return 'Amount exceeds available balance';
                      return null;
                    },
                    onChanged: (_) => _updateFees(context),
                  ),

                  const SizedBox(height: 16),
                  _buildLabel("Payment Type"),
                  Consumer<MyWalletProvider>(
                    builder: (_, walletProvider, __) => TransparentTextField(
                      icon: Iconsax.wallet_check,
                      controller: paymentTypeController,
                      dropdownItems: dropdownDisplayList,
                      onChanged: (value) {
                        walletProvider.setSelectedPaymentType(value!);
                        paymentTypeController.text = value;
                      },
                    ),
                  ),

                  const SizedBox(height: 12),
                  Text(errorText, style: const TextStyle(color: Colors.redAccent, fontSize: 13)),

                  const SizedBox(height: 12),
                  _buildPaymentDetails(selectedPaymentType, bank),

                  const SizedBox(height: 16),
                  Consumer<MyWalletProvider>(
                    builder: (_, walletProvider, __) {
                      final percent = double.tryParse(dashboardProvider.companyInfo?.adminCharge ?? "0") ?? 0.0;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSummaryRow("Processing Fee (${percent.toStringAsFixed(1)}%)", walletProvider.processingFees),
                          const SizedBox(height: 6),
                          _buildSummaryRow("Net Payable", walletProvider.netPayable),
                        ],
                      );
                    },
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
              if (_formKey.currentState?.validate() ?? false) {
                walletProvider.withdrawRequest(
                  context,
                  walletType: "wallet_commission",
                  amount: amountController.text.trim(),
                  paymentType: walletProvider.selectedPaymentType,
                  onSuccess: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Withdrawal request submitted successfully"),backgroundColor: Colors.green,),
                    );
                    Navigator.pop(context,true);
                  },
                  onError: (error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(error),backgroundColor: Colors.red,),
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

  Widget _buildReadOnlyField(String text) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        children: [
          Text(text, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, left: 4),
      child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 3, child: Text(label, style: const TextStyle(color: Colors.white70))),
          const SizedBox(width: 8),
          Expanded(flex: 5, child: Text(value, style: const TextStyle(color: Colors.white), textAlign: TextAlign.right)),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13.5)),
        Text("\$${value.toStringAsFixed(2)}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildPaymentDetails(String type, BankDetailsModel? bank) {
    switch (type) {
      case "BANK":
        return TransparentContainer(
          borderWidth: 4,
          child: Column(children: [
            _buildInfoRow("Bank Name:", bank?.bank?.bank ?? ""),
            _buildInfoRow("Account Holder Name:", bank?.bank?.accountHolderName ?? ""),
            _buildInfoRow("Account Number:", bank?.bank?.accountNumber ?? ""),
            _buildInfoRow("IFSC Code:", bank?.bank?.ifscCode ?? ""),
            _buildInfoRow("IBN Code:", bank?.bank?.ibnCode ?? ""),
            _buildInfoRow("SWIFT Code:", bank?.bank?.swiftCode ?? ""),
            _buildInfoRow("Branch:", bank?.bank?.branch ?? ""),
          ]),
        );
      case "Google Pay":
        return _buildUPIContainer(
          label1: "Google Pay No.:",
          value1: bank?.googlePay?.googlePayNo ?? "",
          label2: "Google Pay ID:",
          value2: bank?.googlePay?.googlePayId ?? "",
          qrUrl: bank?.googlePay?.googlePayQr,
        );
      case "Phone Pay":
        return _buildUPIContainer(
          label1: "Phone Pay No.:",
          value1: bank?.phonePay?.phonePayNo ?? "",
          label2: "Phone Pay ID:",
          value2: bank?.phonePay?.phonePayId ?? "",
          qrUrl: bank?.phonePay?.phonePayQr,
        );
      case "USDT TRC20":
        return TransparentContainer(
          borderWidth: 4,
          child: _buildInfoRow("USDT TRC Address:", bank?.usdtTrc?.usdtAddress ?? ""),
        );
      case "USDT BEP20":
        return TransparentContainer(
          borderWidth: 4,
          child: _buildInfoRow("USDT BEP Address:", bank?.usdtBep?.obdAddress ?? ""),
        );
      default:
        return const SizedBox();
    }
  }

  Widget _buildUPIContainer({
    required String label1,
    required String value1,
    required String label2,
    required String value2,
    String? qrUrl,
  }) {
    return TransparentContainer(
      borderWidth: 4,
      child: Column(
        children: [
          _buildInfoRow(label1, value1),
          _buildInfoRow(label2, value2),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("QR Code:", style: TextStyle(color: Colors.white70)),
              SizedBox(
                height: 100,
                width: 100,
                child: Image.network(
                  qrUrl ?? "",
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.error, color: Colors.white70),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

