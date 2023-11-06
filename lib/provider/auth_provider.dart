import 'package:flutter/material.dart';
import 'package:story_app/api/api_service.dart';
import 'package:story_app/database/preferences.dart';
import 'package:story_app/localization/main.dart';
import 'package:story_app/main.dart';
import 'package:story_app/model/response/login_response.dart';
import 'package:story_app/model/response/register_response.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final Preferences _preferences = Preferences();

  LoginResult? _userToken;
  bool _isFetching = false;
  bool _isLogin = false;
  bool _isPasswordVisible = true;

  bool get isLogin => _isLogin;
  bool get isFetching => _isFetching;
  bool get isPasswordVisible => _isPasswordVisible;
  LoginResult? get userToken => _userToken;

  void setIsLogin(bool isLogin) {
    _isLogin = isLogin;
    notifyListeners();
  }

  void setIsFetching(bool isFetching) {
    _isFetching = isFetching;
    notifyListeners();
  }

  void setIsPasswordVisible(bool isPasswordVisible) {
    _isPasswordVisible = isPasswordVisible;
    notifyListeners();
  }

  Future<LoginResult?> login(String email, String password) async {
    try {
      _isFetching = true;
      notifyListeners();
      var response = await _apiService.login(email, password);
      // set user token
      showMyDialog(
        AppLocalizations.of(navigatorKey.currentContext!)!.loginSuccess,
        response.message,
      );
      await _preferences.saveUser(response.loginResult);
      return _userToken = response.loginResult;
    } catch (e) {
      _isFetching = false;
      notifyListeners();
      // throw alert error
      showMyDialog(
        AppLocalizations.of(navigatorKey.currentContext!)!.loginFailed,
        e.toString(),
      );
      return _userToken = null;
    } finally {
      _isFetching = false;
      notifyListeners();
    }
  }

  Future<RegisterResponse> register(
      String name, String email, String password) async {
    try {
      _isFetching = true;
      notifyListeners();
      var response = await _apiService.register(name, email, password);
      // set user token
      notifyListeners();
      showMyDialog(
        AppLocalizations.of(navigatorKey.currentContext!)!.loginSuccess,
        response.message,
      );
      return response;
    } catch (e) {
      _isFetching = false;
      notifyListeners();
      // throw alert error
      showMyDialog(
        AppLocalizations.of(navigatorKey.currentContext!)!.registerFailed,
        e.toString(),
      );
      return RegisterResponse(
        error: true,
        message: e.toString(),
      );
    } finally {
      _isFetching = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      _isFetching = true;
      await _preferences.removeUser();
      _userToken = null;
      notifyListeners();
      showMyDialog(
        AppLocalizations.of(navigatorKey.currentContext!)!.logoutSuccess,
        'Logout success',
      );
    } catch (e) {
      _isFetching = false;
      notifyListeners();
      // throw alert error
      showMyDialog(
        AppLocalizations.of(navigatorKey.currentContext!)!.loginFailed,
        e.toString(),
      );
    } finally {
      _isFetching = false;
      notifyListeners();
    }
  }
}
