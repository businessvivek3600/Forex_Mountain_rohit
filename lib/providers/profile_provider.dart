// import 'package:flutter/material.dart';
// import 'package:forex_mountain/database/model/response/base/user_model.dart';

// class ProfileProvider extends ChangeNotifier {
//   bool isLoading = true;

//   UserModel user = UserModel(
//     firstName: 'YALLAPPA Y',
//     lastName: 'NAREYAVAR',
//     email: 'manjuyn5318@gmail.com',
//     mobile: '9972212183',
//     dob: '01-01-1417',
//     zip: '581325',
//     city: 'DANDELI',
//     address1: 'NEAR KANNADA SCHOOL DANDELI',
//     address2: 'DANDELI',
//     house: '# 158 GANDHI NAGAR DANDELI',
//     state: '',
//   );

//   final List<String> stateList = [
//     'Karnataka', 'Maharashtra', 'Goa', 'Tamil Nadu'
//   ];

//   void loadProfileData() async {
//     await Future.delayed(const Duration(seconds: 1)); // simulate API delay
//     isLoading = false;
//     notifyListeners();
//   }

//   void updateField(String field, String value) {
//     switch (field) {
//       case 'firstName':
//         user.firstName = value;
//         break;
//       case 'lastName':
//         user.lastName = value;
//         break;
//       case 'mobile':
//         user.mobile = value;
//         break;
//       case 'dob':
//         user.dob = value;
//         break;
//       case 'zip':
//         user.zip = value;
//         break;
//       case 'city':
//         user.city = value;
//         break;
//       case 'house':
//         user.house = value;
//         break;
//       case 'address1':
//         user.address1 = value;
//         break;
//       case 'address2':
//         user.address2 = value;
//         break;
//       case 'state':
//         user.state = value;
//         break;
//     }
//     notifyListeners();
//   }
// }