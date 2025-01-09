import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:forex_mountain/providers/deposit_request_provider.dart';
import 'package:forex_mountain/screens/drawerPages/deposit_request/deposit_request_history_page.dart';
import 'package:forex_mountain/utils/default_logger.dart';
import 'package:forex_mountain/utils/sizedbox_utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants/app_constants.dart';
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
String token = "";
  @override
  void initState() {
    super.initState();
    provider.getDepositData();
    _initializeToken();
  }

  @override
  void dispose() {
    _amountController.dispose();

    _txnIdController.dispose();
    super.dispose();
  }
  Future<void> _initializeToken() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      token = sharedPreferences.getString(SPConstants.userToken) ?? "";
    });
    infoLog("Token loaded successfully: $token");

  }


  Future<void> uploadImage() async {
    // Check if the form is valid
    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(
        msg: 'Please fill all required fields.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red
      );
      return;
    }

    String amount = _amountController.text.trim();
    String txnId = _txnIdController.text.trim();
    String paymentType = provider.selectedPaymentType ?? '';

    if (provider.selectedFile == null) {
      Fluttertoast.showToast(
        msg: 'Please upload a payment slip.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red
      );
      return;
    }

    try {
      var stream = http.ByteStream(provider.selectedFile!.openRead().cast());
      var length = await provider.selectedFile!.length();

      var uri = Uri.parse('https://eagle.forexmountains.com/api/customer/deposit-submit');

      var request = http.MultipartRequest('POST', uri);
      request.fields['amount'] = amount;
      request.fields['txn_id'] = txnId;
      request.fields['payment_type'] = paymentType;
      request.fields['login_token'] = token;
      request.headers['Content-Type'] = 'application/json';
      request.headers['X-API-KEY'] = AppConstants.authorizationToken;

      var multipartFile = http.MultipartFile(
        'slip',
        stream,
        length,
        filename: provider.selectedFile!.path.split('/').last,
      );
      request.files.add(multipartFile);

      var response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final Map<String, dynamic> responseMap = json.decode(responseBody);

        // Assuming the API returns a 'message' field in the response
        final String responseMessage = responseMap['message'] ?? 'Request submitted successfully';

        Fluttertoast.showToast(
          msg: responseMessage,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
        );
        // Clear fields after successful submission
        _formKey.currentState!.reset();
        _amountController.clear();
        _txnIdController.clear();
        provider.clearSelectedFile();
        provider.setSelectedPaymentType(null, "");

        // Delay for 2 seconds before navigating to the next screen
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const DepositHistoryRequestsPage(),
            ),
          );
        });
      } else {
        final responseBody = await response.stream.bytesToString();
        Fluttertoast.showToast(
          msg: 'Error: $responseBody',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'An error occurred: $e',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
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
              final paymentTypes = provider.depositRequest?.paymentTypes ?? [];

              return SingleChildScrollView(
                child: Column(
                  children: [
                    height20(),
                    Card(
                      elevation: 8,
                      shadowColor: Colors.white54,
                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                              const Text(
                                'Amount',
                                style: TextStyle(color: Colors.white, fontSize: 14),
                              ),
                              height10(),
                              SizedBox(
                                height: 60,
                                child: TextFormField(
                                  controller: _amountController,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')), // Allows numbers and one decimal point
                                  ],
                                  keyboardType:
                                  const TextInputType.numberWithOptions(decimal: true),
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
                              const Text(
                                'Payment Type',
                                style: TextStyle(color: Colors.white, fontSize: 14),
                              ),
                              height10(),
                              SizedBox(
                                height: 60,
                                child: DropdownButtonFormField<String>(
                                  value: provider.selectedPaymentType,
                                  dropdownColor: Colors.black87,
                                  iconDisabledColor: Colors.white,
                                  hint: const Text(
                                    'Select Payment Type',
                                    style: TextStyle(color: Colors.white),
                                  ),
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
                                  onChanged: (String? newType) {
                                    final selectedType = paymentTypes.firstWhere(
                                          (type) => type.type == newType,
                                    );
                                    provider.setSelectedPaymentType(
                                      selectedType.type,
                                      selectedType.image,
                                    );
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select a payment type';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              // QR Code Section
                              if (provider.selectedPaymentImage != null && provider.selectedPaymentImage != '')
                                Center(
                                  child: Column(
                                    children: [
                                      height20(),
                                      const Text(
                                        'Payment Detail :',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
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
                              const Text(
                                'Upload Slip',
                                style: TextStyle(color: Colors.white, fontSize: 14),
                              ),
                              height10(),
                              Consumer<DepositRequestProvider>(
                                builder: (context, provider, child) => Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.black26,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          provider.fileName,
                                          style: const TextStyle(color: Colors.white70),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: provider.pickFile,
                                        child: const Text(
                                          'Choose file',
                                          style: TextStyle(color: Colors.blueAccent),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              height20(),
                              // Transaction Detail Field
                              const Text(
                                'Transaction Detail / Number',
                                style: TextStyle(color: Colors.white, fontSize: 14),
                              ),
                              height10(),
                              SizedBox(
                                height: 60,
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
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter transaction details';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              height40(),
                              // Submit Button
                              Center(
                                child: SizedBox(
                                  height: 60,
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                    ),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        uploadImage();
                                      }
                                    },
                                    child: const Text(
                                      'Submit',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
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
        )
        ,
      ),
    );
  }
}
