


import 'package:flutter/cupertino.dart';
import 'package:forex_mountain/my_forex_mountain/repositories/my_mlm_repo.dart';

import '../my.model/my_team_view_model.dart';
import '../my.screens/functions/my_function.dart';

class MyMlmProvider extends ChangeNotifier {
  final MyMLMRepo mlmRepo;

  MyMlmProvider({required this.mlmRepo});

  bool _isLoading = false;
  String? _errorMessage;
  List<MyTeamMember> _teamMembers = [];
  List<MyTeamMember> _directMembers = [];



  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<MyTeamMember> get teamMembers => _teamMembers;
  List<MyTeamMember> get directMembers => _directMembers;

  Future<void> fetchMyTeamData(BuildContext context) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final apiResponse = await mlmRepo.getMyTeamData();
    await handleSessionExpired(context,  apiResponse.response?.data);
    if (apiResponse.response != null &&
        apiResponse.response?.data['status'] == true) {
      try {
        final jsonList = apiResponse.response!.data['data'] as List<dynamic>;
        _teamMembers =
            jsonList.map((json) => MyTeamMember.fromJson(json)).toList();
      } catch (e) {
        _errorMessage = 'Failed to parse team data';
        _teamMembers = [];
      }
    } else {
      _errorMessage = apiResponse.error ?? 'Unknown error';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchDirectMemberData(BuildContext context) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final apiResponse = await mlmRepo.getDirectMemberData();
    await handleSessionExpired(context, apiResponse.response?.data);

    if (apiResponse.response != null &&
        apiResponse.response?.data['status'] == true) {
      try {
        final jsonList = apiResponse.response!.data['data'] as List<dynamic>;
        _directMembers =
            jsonList.map((json) => MyTeamMember.fromJson(json)).toList();
      } catch (e) {
        _errorMessage = 'Failed to parse direct member data';
        _directMembers = [];
      }
    } else {
      _errorMessage = apiResponse.error ?? 'Unknown error';
    }

    _isLoading = false;
    notifyListeners();
  }



}