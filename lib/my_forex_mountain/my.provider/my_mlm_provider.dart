import 'package:flutter/cupertino.dart';
import 'package:forex_mountain/my_forex_mountain/repositories/my_mlm_repo.dart';

import '../my.model/my_generation_model.dart';
import '../my.model/my_team_view_model.dart';
import '../my.screens/functions/my_function.dart';

class MyMlmProvider extends ChangeNotifier {
  final MyMLMRepo mlmRepo;

  MyMlmProvider({required this.mlmRepo});


  bool _isFirstLoad = false;
  bool _isPaginating = false;
  bool _hasMore = true;
  int _currentPage = 1;
  String? _errorMessage;
  List<MyTeamMember> _teamMembers = [];
  List<MyTeamMember> _directMembers = [];


  bool get isFirstLoad => _isFirstLoad;
  bool get isPaginating => _isPaginating;
  bool get hasMore => _hasMore;
  String? get errorMessage => _errorMessage;
  List<MyTeamMember> get teamMembers => _teamMembers;
  List<MyTeamMember> get directMembers => _directMembers;
  void resetTeam() {
    _teamMembers = [];
    _directMembers = [];
    _currentPage = 1;
    _hasMore = true;
    notifyListeners();
  }

  Future<void> fetchMyTeamData(BuildContext context,
      {bool loadMore = false}) async {
    if (loadMore && (_isPaginating || !_hasMore)) return;
    if (!loadMore && _isFirstLoad) return;
    if (loadMore) {
      _isPaginating = true;
    } else {
      _isFirstLoad = true;
    }
    _errorMessage = null;
    notifyListeners();
    try {
      final map = {
        'page': _currentPage.toString(),
      };
      final apiResponse = await mlmRepo.getMyTeamData(map);
      await handleSessionExpired(context, apiResponse.response?.data);
      if (apiResponse.response?.statusCode == 200) {
        final responseData = apiResponse.response?.data;
        final List<dynamic> result = responseData?['data'] ?? [];
        final newList = result.map((e) => MyTeamMember.fromJson(e)).toList();
        if (loadMore) {
          _teamMembers.addAll(newList);
        } else {
          _teamMembers = newList;
        }
        _hasMore = newList.isNotEmpty;
        if (_hasMore) _currentPage++;
      } else {
        _errorMessage = 'Failed to fetch Team Member';
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
    } finally {
      _isFirstLoad = false;
      _isPaginating = false;
      notifyListeners();
    }
  }

  Future<void> fetchDirectMemberData(BuildContext context,
      {bool loadMore = false}) async {
    if (loadMore && (_isPaginating || !_hasMore)) return;
    if (!loadMore && _isFirstLoad) return;
    if (loadMore) {
      _isPaginating = true;
    } else {
      _isFirstLoad = true;
    }
    _errorMessage = null;
    notifyListeners();
    try {
      final map = {
        'page': _currentPage.toString(),
      };
      final apiResponse = await mlmRepo.getDirectMemberData(map);
      await handleSessionExpired(context, apiResponse.response?.data);
      if (apiResponse.response?.statusCode == 200) {
        final responseData = apiResponse.response?.data;
        final List<dynamic> result = responseData?['data'] ?? [];
        final newList = result.map((e) => MyTeamMember.fromJson(e)).toList();
        if (loadMore) {
          _directMembers.addAll(newList);
        } else {
          _directMembers = newList;
        }
        _hasMore = newList.isNotEmpty;
        if (_hasMore) _currentPage++;
      } else {
        _errorMessage = 'Failed to fetch Team Member';
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
    } finally {
      _isFirstLoad = false;
      _isPaginating = false;
      notifyListeners();
    }
  }
  ///GENERATION DATA
  GenerationalTreeResponse? _generationData;
  GenerationalTreeResponse? get generationData => _generationData;

  bool _isLoadingGeneration = false;
  bool get isLoadingGeneration => _isLoadingGeneration;

  String? _generationError;
  String? get generationError => _generationError;

  Future<void> fetchGenerationData(BuildContext context, {String customerId = ''}) async {
    _isLoadingGeneration = true;
    _generationError = null;
    notifyListeners();

    try {
      final map = {'customer_id': customerId};
      final apiResponse = await mlmRepo.getGenerationData(map);
      await handleSessionExpired(context, apiResponse.response?.data);

      if (apiResponse.response?.statusCode == 200) {
        final responseData = apiResponse.response?.data;
        _generationData = GenerationalTreeResponse.fromJson(responseData);
      } else {
        _generationError = 'Failed to fetch generation data';
      }
    } catch (e) {
      _generationError = 'Error: $e';
    } finally {
      _isLoadingGeneration = false;
      notifyListeners();
    }
  }


}
