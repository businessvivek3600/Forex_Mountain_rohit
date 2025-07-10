import 'package:flutter/material.dart';

import '../../../utils/picture_utils.dart';
import '../../../utils/text.dart';

class TransferToWallet extends StatefulWidget {
  const TransferToWallet({super.key});

  @override
  State<TransferToWallet> createState() => _TransferToWalletState();
}

class _TransferToWalletState extends State<TransferToWallet> {
  final _formKey = GlobalKey<FormState>();
  final double walletBalance = 474.38;
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
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: bodyLargeText('Withdraw Fund', context, fontSize: 20),
          backgroundColor: Colors.black,
          elevation: 0,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
