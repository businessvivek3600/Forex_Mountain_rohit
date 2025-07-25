import 'package:flutter/material.dart';
import 'package:forex_mountain/my_forex_mountain/my.screens/profile/add_payment_details.dart';

import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../../../screens/dashboard/main_page.dart';
import '../../../utils/picture_utils.dart';
import '../../../utils/text.dart';
import '../../my.constant/my_enums.dart';
import '../../my.model/my_bank_model.dart';
import '../../my.provider/my_dashboard_provider.dart';
import '../../widgets/glass_card.dart';

class PaymentDetailsPage extends StatefulWidget {
  const PaymentDetailsPage({super.key});

  @override
  State<PaymentDetailsPage> createState() => _PaymentDetailsPageState();
}

class _PaymentDetailsPageState extends State<PaymentDetailsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MyDashboardProvider>(context, listen: false)
          .getBankDetails(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyDashboardProvider>(
      builder: (context, dashboardProvider, child) {
        final isLoading = dashboardProvider.isLoadingBank;
        final paymentDetails = dashboardProvider.bankDetails;

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
              title: bodyLargeText("Payment Detail", context),
              backgroundColor: Colors.black,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.amber),
            ),
            body: SafeArea(
              child: isLoading
                  ? _buildShimmer()
                  : paymentDetails == null
                      ? const Center(
                          child: Text("No data available",
                              style: TextStyle(color: Colors.white70)))
                      : _buildPaymentDetails(paymentDetails),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPaymentDetails(BankDetailsModel details) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(
              title: "WALLET ADDRESS",
              condition: _hasWalletData(details),
              buildContent: () => _buildWalletSection(
                    details,
                  ),
              icon: Iconsax.wallet,
              fallbackText: "Add Wallet Details",
              onTap: () async {
                final updated = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddPaymentDetails(
                            initialData: details,
                            section: PaymentSection.wallet,
                          )),
                );
                if (updated == true) {
                  Provider.of<MyDashboardProvider>(context, listen: false)
                      .getBankDetails(context);
                }
              }),
          const SizedBox(height: 20),
          _buildSection(
              title: "PHONE PAY",
              condition: _hasPhonePeData(details),
              buildContent: () => _buildUpiSection(
                      "PHONE PAY",
                      details.phonePay?.phonePayNo,
                      details.phonePay?.phonePayId,
                      details.phonePay?.phonePayQr, () async {
                    final updated = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddPaymentDetails(
                                initialData: details,
                                section: PaymentSection.phonePe,
                              )),
                    );
                    if (updated == true) {
                      Provider.of<MyDashboardProvider>(context, listen: false)
                          .getBankDetails(context);
                    }
                  }),
              icon: Iconsax.wallet_check,
              fallbackText: "Add PhonePe Details",
              onTap: () async {
                final updated = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddPaymentDetails(
                            initialData: details,
                            section: PaymentSection.phonePe,
                          )),
                );
                if (updated == true) {
                  Provider.of<MyDashboardProvider>(context, listen: false)
                      .getBankDetails(context);
                }
              }),
          const SizedBox(height: 20),
          _buildSection(
              title: "GOOGLE PAY",
              condition: _hasGooglePayData(details),
              buildContent: () => _buildUpiSection(
                      "GOOGLE PAY",
                      details.googlePay?.googlePayNo,
                      details.googlePay?.googlePayId,
                      details.googlePay?.googlePayQr, () async {
                    final updated = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddPaymentDetails(
                                initialData: details,
                                section: PaymentSection.googlePay,
                              )),
                    );
                    if (updated == true) {
                      Provider.of<MyDashboardProvider>(context, listen: false)
                          .getBankDetails(context);
                    }
                  }),
              icon: Iconsax.wallet_3,
              fallbackText: "Add Google Pay Details",
              onTap: () async {
                final updated = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddPaymentDetails(
                            initialData: details,
                            section: PaymentSection.googlePay,
                          )),
                );
                if (updated == true) {
                  Provider.of<MyDashboardProvider>(context, listen: false)
                      .getBankDetails(context);
                }
              }),
          const SizedBox(height: 20),
          _buildSection(
              title: "BANK DETAILS",
              condition: _hasBankData(details.bank),
              buildContent: () => _buildBankSection(details.bank!),
              icon: Iconsax.bank,
              fallbackText: "Add Bank Details",
              onTap: () async {
                final updated = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddPaymentDetails(
                            initialData: details,
                            section: PaymentSection.bank,
                          )),
                );
                if (updated == true) {
                  Provider.of<MyDashboardProvider>(context, listen: false)
                      .getBankDetails(context);
                }
              }),
        ],
      ),
    );
  }

  /// Helpers

  bool _hasWalletData(BankDetailsModel details) =>
      details.usdtTrc?.usdtAddress?.isNotEmpty == true ||
      details.usdtBep?.obdAddress?.isNotEmpty == true;

  bool _hasPhonePeData(BankDetailsModel details) =>
      details.phonePay?.phonePayNo?.isNotEmpty == true ||
      details.phonePay?.phonePayId?.isNotEmpty == true ||
      details.phonePay?.phonePayQr?.isNotEmpty == true;

  bool _hasGooglePayData(BankDetailsModel details) =>
      details.googlePay?.googlePayNo?.isNotEmpty == true ||
      details.googlePay?.googlePayId?.isNotEmpty == true ||
      details.googlePay?.googlePayQr?.isNotEmpty == true;

  bool _hasBankData(BankModel? bank) =>
      bank?.bank?.isNotEmpty == true ||
      bank?.branch?.isNotEmpty == true ||
      bank?.accountHolderName?.isNotEmpty == true ||
      bank?.accountNumber?.isNotEmpty == true ||
      bank?.ifscCode?.isNotEmpty == true ||
      bank?.ibnCode?.isNotEmpty == true ||
      bank?.swiftCode?.isNotEmpty == true;

  Widget _buildSection({
    required String title,
    required bool condition,
    required Widget Function() buildContent,
    required IconData icon,
    required String fallbackText,
    required VoidCallback onTap,
  }) {
    return condition
        ? buildContent()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(title, showEdit: false),
              const SizedBox(height: 10),
              buildGlassTile(icon, fallbackText, onTap),
            ],
          );
  }

  /// UI Builders

  Widget _buildShimmer() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: List.generate(4, (index) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(12),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildWalletSection(BankDetailsModel details) {
    return Column(
      children: [
        _buildHeader(
          "WALLET ADDRESS",
          showEdit: true,
          onEdit: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddPaymentDetails(
                initialData: details,
                section: PaymentSection.wallet,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        GlassCard(
          child: Column(
            children: [
              if (details.usdtTrc?.usdtAddress?.isNotEmpty == true)
                _buildRow("USDT (TRC20)", details.usdtTrc!.usdtAddress!),
              if (details.usdtBep?.obdAddress?.isNotEmpty == true) ...[
                const SizedBox(height: 12),
                _buildRow("USDT (BEP20)", details.usdtBep!.obdAddress!),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUpiSection(String label, String? number, String? id,
      String? qrUrl, VoidCallback onEdit) {
    return Column(
      children: [
        _buildHeader(label, showEdit: true, onEdit: onEdit),
        const SizedBox(height: 10),
        GlassCard(
          child: Column(
            children: [
              if (number?.isNotEmpty == true)
                _buildRow("$label NUMBER", number!),
              if (id?.isNotEmpty == true) ...[
                const SizedBox(height: 12),
                _buildRow("$label ID", id!),
              ],
              if (qrUrl?.isNotEmpty == true) ...[
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 140,
                      child: Text("QR Code",
                          style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Image.network(qrUrl!, height: 100, width: 100),
                    ),
                  ],
                )
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBankSection(BankModel bank) {
    return Column(
      children: [
        _buildHeader(
          "BANK DETAILS",
          showEdit: true,
          onEdit: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddPaymentDetails(
                initialData:
                    Provider.of<MyDashboardProvider>(context, listen: false)
                        .bankDetails!,
                section: PaymentSection.bank,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        GlassCard(
          child: Column(
            children: [
              _buildRow("Bank", bank.bank ?? ""),
              const SizedBox(height: 12),
              _buildRow("Branch", bank.branch ?? ""),
              const SizedBox(height: 12),
              _buildRow("Account Holder", bank.accountHolderName ?? ""),
              const SizedBox(height: 12),
              _buildRow("Account Number", bank.accountNumber ?? ""),
              const SizedBox(height: 12),
              _buildRow("IFSC Code", bank.ifscCode ?? ""),
              const SizedBox(height: 12),
              _buildRow("IBN Code", bank.ibnCode ?? ""),
              const SizedBox(height: 12),
              _buildRow("SWIFT Code", bank.swiftCode ?? ""),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(String title,
      {bool showEdit = true, VoidCallback? onEdit}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        UiCategoryTitleContainer(child: _buildLabelHeadLine(title)),
        if (showEdit)
          IconButton(
            icon: const Icon(Iconsax.edit, color: Colors.amber, size: 20),
            onPressed: onEdit,
          ),
      ],
    );
  }

  Widget _buildRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: Colors.white54),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildGlassTile(IconData icon, String label, VoidCallback onTap) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            Icon(icon, color: Colors.amber),
            const SizedBox(width: 12),
            Expanded(
                child: Text(label,
                    style: const TextStyle(color: Colors.white, fontSize: 16))),
            const Icon(Iconsax.arrow_right_3, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildLabelHeadLine(String text) {
    return Text(
      text,
      style: const TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
    );
  }
}
