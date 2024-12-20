import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'package:forex_mountain/providers/deposit_request_provider.dart';
import 'package:forex_mountain/screens/drawerPages/deposit_request/deposit_request_history_page.dart';
import 'package:forex_mountain/utils/default_logger.dart';
import 'package:forex_mountain/utils/sizedbox_utils.dart';
import 'package:provider/provider.dart';
import '../../../sl_container.dart';
import '../../../utils/color.dart';
import 'package:http/http.dart' as http;
import '../../../utils/picture_utils.dart';
import '../../../utils/text.dart';

class DepositRequestScreen extends StatefulWidget {
  const DepositRequestScreen({super.key});
  static const String routeName = 'DepositRequest';

  @override
  State<DepositRequestScreen> createState() => _DepositRequestScreenState();
}

class _DepositRequestScreenState extends State<DepositRequestScreen> {
  var provider = sl.get<DepositRequestProvider>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _txnIdController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? selectedPaymentType;

  @override
  void initState() {
    super.initState();
    provider.getDepositData();
  }

  @override
  void dispose() {
    _amountController.dispose();

    _txnIdController.dispose();
    super.dispose();
  }
  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      String amount = _amountController.text.trim();
      String txnId = _txnIdController.text.trim();
      String paymentType = provider.selectedPaymentType ?? '';

      // Check if a file is selected
      if (provider.selectedFile != null) {
        try {
          // Prepare the data with the MultipartFile for the file
          Map<String, dynamic> data = {
            'amount': amount,
            'txn_id': txnId,
            'payment_type': paymentType,
          };
           var length = await provider.selectedFile!.length();
          var stream = http.ByteStream(provider.selectedFile!.openRead());
          stream.cast();
          // Add file to the data map
          var slipFile = http.MultipartFile(
            "slip",
           stream,
            length,
              filename: "upload_slip.jpg", // Set the file name if not automatically set
              contentType: MediaType('image', 'jpeg'),
          );
          data['slip'] = slipFile;

          // Log the data being sent to the API
          infoLog('________________________________________________________________');
          infoLog('Data to send to API: $data');
          infoLog('File to send: ${slipFile.contentType}');
          infoLog('Slip File Details:');
          infoLog('File name: ${slipFile.filename}');
          infoLog('File size: ${slipFile.length} bytes');
          infoLog('File content type: ${slipFile.contentType}');
          infoLog('________________________________________________________________');
          // Call the provider method to submit the data
          await provider.putDepositData(data);

          // Clear inputs after successful submission
          _amountController.clear();
          _txnIdController.clear();
          setState(() {
            selectedPaymentType = null;
            provider.clearSelectedFile();
            provider.clearSelectedPaymentType();
          });
        } catch (e) {
          infoLog('Error during submission: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('An error occurred. Please try again.')),
          );
        }
      } else {
        // Handle file not selected
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please upload the slip')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        title: titleLargeText('Deposit Request', context, useGradient: true),
        elevation: 1,
        actions: [
          Row(
            children: [
              // if (Platform.isAndroid)
              SizedBox(
                height: 25,
                child: ElevatedButton(
                  onPressed:
                      () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const DepositHistoryRequestsPage(),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    // backgroundColor: appLogoColor,
                    backgroundColor: Colors.transparent,
                    padding: const EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(color: appLogoColor)),
                  ),
                  child: bodyLargeText('History', context,
                      fontWeight: FontWeight.normal),
                ),
              ),
              width10(),
            ],
          ),
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: userAppBgImageProvider(context),
            fit: BoxFit.cover,
            opacity: 3,
          ),
        ),
        child: Form(
          key: _formKey,
          child: Consumer<DepositRequestProvider>(
            builder: (context, provider, child) {
              // Fetch payment types from provider
              final paymentTypes = provider.depositRequest?.paymentTypes ?? [];

              return SingleChildScrollView(
                child: Column(
                  children: [
                    height20(),
                    Card(
                      elevation: 8,
                      shadowColor: Colors.white54,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Center(
                                child: Text(
                                  'Request Amount',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Amount Field
                              const Text('Amount',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14)),
                              height10(),
                              SizedBox(
                                height: 60,
                                child: TextFormField(
                                  controller: _amountController,
                                    // autovalidateMode: AutovalidateMode.onUserInteraction,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    errorMaxLines: 1,
                                    filled: true,
                                    fillColor: Colors.black26,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter an amount';
                                    }
                                    final amount = double.tryParse(value);
                                    if (amount == null) {
                                      return 'Please enter a valid number';
                                    }
                                    if (amount < 50) {
                                      return 'Amount must be at least 50';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              height20(),
                              // Payment Type Dropdown
                              const Text('Payment Type',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14)),
                              height10(),
                              SizedBox(
                                height: 40,
                                child: DropdownButtonFormField<String>(
                                  value: selectedPaymentType,
                                  dropdownColor: Colors.black87,
                                  iconDisabledColor: Colors.white,
                                  hint: const Text('Select Payment Type',
                                      style: TextStyle(color: Colors.white)),
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.black26,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  items: paymentTypes.map((type) {
                                    return DropdownMenuItem<String>(
                                      value: type.type,
                                      child: Text(type.type),
                                    );
                                  }).toList(),
                                  onChanged:(String? newType) {
                                    final selectedType = paymentTypes.firstWhere(
                                            (type) => type.type == newType,
                                        );
                                    provider.setSelectedPaymentType(
                                      selectedType.type,
                                      selectedType.image,
                                    );
                                  },
                                ),
                              ),

                              // QR Code Section
                              if (provider.selectedPaymentImage != null)
                              Center(
                                child: Column(
                                  children: [
                                    height20(),
                                    const Text(
                                      'Payment Detail :',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 14),
                                    ),
                                    height20(),
                                    Container(
                                      color: Colors.white,
                                      padding: const EdgeInsets.all(8),
                                      child: Image.network(
                                        provider.selectedPaymentImage!,
                                        width: 150,
                                        height: 150,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              height20(),
                              // Upload Slip
                              const Text('Upload Slip',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14)),
                              height10(),
                              Consumer<DepositRequestProvider>(
                                builder: (context, provider, child) =>
                                    Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.black26,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          provider.fileName,
                                          style: const TextStyle(
                                              color: Colors.white70),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: provider.pickFile,
                                        child: const Text(
                                          'Choose file',
                                          style: TextStyle(
                                              color: Colors.blueAccent),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              height20(),
                              // Transaction Detail Field
                              const Text('Transaction Detail / Number',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14)),
                              height10(),
                              SizedBox(
                                height: 40,
                                child: TextFormField(
                                  style: const TextStyle(color: Colors.white),
                                  controller: _txnIdController,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.black26,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                              height40(),
                              // Submit Button
                              Center(
                                child: SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                    ),
                                    onPressed: () {
                                      _submit();
                                    },
                                    child: const Text(
                                      'Submit',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),
                                ),
                              ),
                              height10(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
