import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';

class ProfileProvider extends ChangeNotifier {
  UserProfile _profile = UserProfile.empty();
  bool _isSetup = false;
  int _currentStep = 0;

  UserProfile get profile => _profile;
  bool get isSetup => _isSetup;
  int get currentStep => _currentStep;

  Future<void> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('user_profile');
    if (data != null) {
      _profile = UserProfile.fromJson(json.decode(data));
      _isSetup = _profile.gender.isNotEmpty;
    }
    notifyListeners();
  }

  Future<void> saveProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_profile', json.encode(_profile.toJson()));
    _isSetup = _profile.gender.isNotEmpty;
    notifyListeners();
  }

  void updateProfile(UserProfile profile) {
    _profile = profile;
    notifyListeners();
  }

  void setStep(int step) {
    _currentStep = step;
    notifyListeners();
  }
}
