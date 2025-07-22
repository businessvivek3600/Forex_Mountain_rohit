import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:forex_mountain/my_forex_mountain/repositories/my_user_repo.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';

import '../../database/model/response/base/api_response.dart';
import '../my.model/my_kyc_model.dart';

class NewUserProvider with ChangeNotifier {
  NewUserRepo newUserRepo;
 NewUserProvider({required this.newUserRepo});
  final ImagePicker _picker = ImagePicker();
  TextEditingController documentNumberController = TextEditingController();

  Country? selectedCountry;
  String selectedDocumentType = 'Select';
  String countryText = '';
  String documentNumber = '';
  File? documentImage;
  File? selfieImage;
  String? documentImageUrl;
  String? selfieImageUrl;

  late  List<String> documentTypes = [];

  void selectCountry(Country country) {
    selectedCountry = country;
    countryText = '${country.name} (${country.countryCode})';
    notifyListeners();
  }

  void setDocumentType(String? type) {
    if (type != null) {
      selectedDocumentType = type;
      notifyListeners();
    }
  }

  void setDocumentNumber(String number) {
    documentNumber = number;
    notifyListeners();
  }
  void resetKycState() {
    selectedCountry = null;
    selectedDocumentType = 'Select';
    countryText = '';
    documentNumber = '';
    documentNumberController.clear();

    documentImage = null;
    selfieImage = null;
    documentImageUrl = null;
    selfieImageUrl = null;
    _kycData = null;
    documentTypes = [];

    notifyListeners();
  }



  Future<void> pickImage({
    required bool isSelfie,
    required ImageSource source,
  }) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source, imageQuality: 80);

    if (pickedFile == null) return;

    final file = File(pickedFile.path);
    final fileSize = await file.length();
    final extension = path.extension(file.path).toLowerCase();

    if (!(extension == '.jpg' || extension == '.jpeg' || extension == '.png')) {
      throw Exception('Only JPG, JPEG, or PNG files are allowed.');
    }

    if (fileSize > 5 * 1024 * 1024) {
      throw Exception('File size must be less than 5MB.');
    }

    if (isSelfie) {
      selfieImage = file;
    } else {
      documentImage = file;
    }

    notifyListeners();
  }

  void removeDocumentImage() {
    documentImage = null;
    notifyListeners();
  }

  void removeSelfieImage() {
    selfieImage = null;
    notifyListeners();
  }

  bool validateKyc() {
    return selectedDocumentType != 'Select' && documentNumber.trim().isNotEmpty;
  }


  bool _isKycSubmitting = false;
  bool get isKycSubmitting => _isKycSubmitting;

  Future<void> submitKyc({
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {

    _isKycSubmitting = true;
    notifyListeners();

    final response = await newUserRepo.submitKycForm(
      countryCode: selectedCountry!.countryCode,
      docType: selectedDocumentType,
      docNumber: documentNumber.trim(),
      uploadFirstProof: documentImage!,
      uploadSecondProof: selfieImage!,
    );

    _isKycSubmitting = false;

    if (response.response != null && response.response!.statusCode == 200) {
      onSuccess();
    } else {
      onError(response.error ?? 'Something went wrong!');
    }

    notifyListeners();
  }

///
  MyKycData? _kycData;
  bool _isLoadingKyc = false;

  MyKycData? get kycData => _kycData;
  bool get isLoadingKyc => _isLoadingKyc;
  bool get isKycApproved => _kycData?.kycStatus == 1;
  bool get isKycRejected => _kycData?.kycStatus == 2;
  bool get isKycPending => _kycData?.kycStatus == 0 || _kycData?.kycStatus == null;

  Future<void> getKycData() async {
    _isLoadingKyc = true;
    notifyListeners();

    final  response = await newUserRepo.getKycData();

    _isLoadingKyc = false;

    if (response.response != null && response.response!.statusCode == 200) {
      try {
        _kycData = MyKycData.fromJson(response.response!.data['data']);
        documentNumber = _kycData!.docNumber ?? '';
        documentNumberController.text = documentNumber;
        documentTypes = _kycData!.docTypeSel ?? [];
        documentImageUrl = _kycData!.uploadFirstProof;

        selfieImageUrl = _kycData!.uploadSecondProof;
        selectedDocumentType = _kycData!.docType ?? 'Select';
        if (_kycData?.countrySortname!= null) {
          final country = Country.tryParse(_kycData!.countrySortname!);
          if (country != null) {
            selectedCountry = country;
            countryText = '${country.name} (${country.countryCode})';
          }
        }
      } catch (e) {
        print("Error parsing KYC Data: $e");
      }
    } else {
      print("Failed to fetch KYC Data: ${response.error}");
    }

    notifyListeners();
  }


}
