import 'package:flutter/material.dart';
import 'package:forex_mountain/my_forex_mountain/my.screens/drawer/packages/packages.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../../../../utils/picture_utils.dart';
import '../../../../utils/text.dart';
import '../../../my.model/my_packages_model.dart';
import '../../../my.provider/my_mlm_provider.dart';


class BuyPackageScreen extends StatefulWidget {
  const BuyPackageScreen({super.key, this.myPackages});
  final Packages? myPackages;
  @override
  State<BuyPackageScreen> createState() => _BuyPackageScreenState();
}

class _BuyPackageScreenState extends State<BuyPackageScreen> {
  Package? selectedPackage;
  String? selectedDuration;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final allPackages = [
      ...?widget.myPackages?.fct,
      ...?widget.myPackages?.mtp,
      ...?widget.myPackages?.sip,
    ];
    final sipDurations = widget.myPackages?.sip
        ?.map((pkg) => pkg.duration)
        .toSet()
        .toList();
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: userAppBgImageProvider(context),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: bodyLargeText('Buy Packages', context, fontSize: 20),
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.amber),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Plan',
                        style:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: Colors.white)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<Package>(
                      value: selectedPackage,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.white70),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.amber, width: 2),
                        ),
                      ),
                      dropdownColor: Colors.black87,
                      icon: Icon(Iconsax.arrow_down_1, color: Colors.amber),
                      hint: Text("Choose a Package", style: TextStyle(color: Colors.white70)),
                      items: allPackages.map((pkg) {
                        return DropdownMenuItem<Package>(
                          value: pkg,
                          child: Text(
                            pkg.name ?? 'Unnamed Package',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                      onChanged: (pkg) {
                        setState(() {
                          selectedPackage = pkg;

                          // Auto-select duration if SIP package
                          if (pkg?.planId == '3') {
                            selectedDuration = pkg?.duration;
                          } else {
                            selectedDuration = null;
                          }
                        });
                      },
                    ),

                    const SizedBox(height: 20),
                    const Text('Invest Amount',
                        style:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: Colors.white)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _amountController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.amber, width: 2),
                        ),
                        hintText: 'Enter amount',
                        hintStyle: const TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: Colors.white12,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Amount is required';
                        }
                        final amount = double.tryParse(value);
                        final min = double.tryParse(selectedPackage?.minAmt ?? '0');
                        if (amount == null) {
                          return 'Enter a valid number';
                        }
                        if (min != null && amount < min) {
                          return 'Minimum amount is \$${min.toStringAsFixed(2)}';
                        }
                        return null;
                      },
                    ),

                    if (selectedPackage?.planId == '3') ...[
                      const SizedBox(height: 20),
                      const Text("Selected SIP Plan Duration",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white12,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          prefixIcon: const Icon(Iconsax.timer,color: Colors.white54,),
                        ),
                        dropdownColor: Colors.black87,
                        value: selectedDuration,
                        hint: const Text("Choose duration (months)", style: TextStyle(color: Colors.white70)),
                        iconEnabledColor: Colors.white,
                        style: const TextStyle(color: Colors.white),
                        items: sipDurations?.map((d) {
                          return DropdownMenuItem(
                            value: d,
                            child: Text("$d months", style: const TextStyle(color: Colors.white)),
                          );
                        }).toList(),
                        onChanged: null,
                      ),
                    ],
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 12),
                        ),
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            final planId = selectedPackage?.planId;
                            final amount = _amountController.text.trim();
                            final duration = selectedPackage?.planId == '3' ? selectedDuration : null;

                            if (planId != null) {
                              Provider.of<MyMlmProvider>(context, listen: false).purchasePackage(
                                context,
                                planId: planId,
                                amount: amount,
                                duration: duration,
                              );
                            } else {
                              showCustomToast(context, "Please select a valid package", isError: true);
                            }
                          }
                        },
                        child: const Text("Purchase Package"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
