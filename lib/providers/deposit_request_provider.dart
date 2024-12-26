import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:forex_mountain/utils/default_logger.dart';
import 'package:http/http.dart'as http;
import 'package:http_parser/http_parser.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../database/model/response/deposit_model.dart';
import '../database/repositories/deposit_repo.dart';
import '/database/functions.dart';
import '/database/model/response/base/api_response.dart';

class DepositRequestProvider extends ChangeNotifier {
  final DepositRepo depositRepo;

  DepositRequestProvider({required this.depositRepo});

  // File Picker
  File? _selectedFile;
  String _fileName = 'No file chosen';

  File? get selectedFile => _selectedFile;
  String get fileName => _fileName;

  // Deposit Response
  DepositRequest? _depositRequest;

  DepositRequest? get depositRequest => _depositRequest;

  // Fund Packages
  List<FundPackage> get fundPackages => _depositRequest?.fundPackage ?? [];

  // Selected Payment Type
  String? _selectedPaymentType;
  String? _selectedPaymentImage ;
  String? get selectedPaymentType => _selectedPaymentType;


  String? get selectedPaymentImage => _selectedPaymentImage;

  void setSelectedPaymentType(String? type, String image) {
    _selectedPaymentType = type;
    _selectedPaymentImage= image;
    notifyListeners();
  }

  // File Picker Function
  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
    );

    if (result != null) {
      _selectedFile = File(result.files.single.path!);
      _fileName = result.files.single.name;
      notifyListeners();
    }
  }
//validation



  // Fetch Deposit Data
  Future<void> getDepositData() async {
    if (isOnline) {

      ApiResponse apiResponse = await depositRepo.getDepositRequest();

      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        // Parse JSON into DepositRequest model
        infoLog("___________deposit__________________");
        print(apiResponse.response!.data);
        _depositRequest =
            DepositRequest.fromJson(apiResponse.response!.data);


        notifyListeners(); // Notify UI to update
      } else {
        // Handle API error
        print('Error: ${apiResponse.error}');
      }
    } else {
      print('No internet connection');
    }
  }
  void clearSelectedPaymentType() {
    _selectedPaymentType = null;
    _selectedPaymentImage = null; // Optional, if you are displaying an image
    notifyListeners();
  }
  void clearSelectedFile() {
    _selectedFile = null;
    _fileName = 'No file selected';
    notifyListeners();
  }

  ///put deposit request
  // Fetch Deposit Data
  Future<void> putDepositData(Map<String,dynamic> data) async {
    if (isOnline) {
      if (_selectedFile != null) {
        try {
          final fileSize = _selectedFile!.lengthSync();
          if (fileSize > 5 * 1024 * 1024) { // Example: limit to 5MB
            Fluttertoast.showToast(
              msg: 'File size exceeds 5MB. Please upload a smaller file.',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
            );
            return;
          }

          ApiResponse apiResponse = await depositRepo.putDepositRequest(data: data);

          if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
            print(apiResponse.response!.data);
            Fluttertoast.showToast(
              msg: apiResponse.response!.data["message"].toString(),
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
            );
            notifyListeners();
          } else {
            Fluttertoast.showToast(
              msg: 'Error: ${apiResponse.response?.statusCode ?? 'Unknown error'}',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
            );
          }
        } catch (e) {
          print('Exception: $e');
          Fluttertoast.showToast(
            msg: 'An exception occurred. Please try again.',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: 'No file selected. Please select a file.',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: 'No internet connection. Please check your connection.',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }





  // Clear State
  void clear() {
    _depositRequest = null;
    _selectedFile = null;
    _fileName = 'No file chosen';
    _selectedPaymentType = null;
    notifyListeners();
  }
}
