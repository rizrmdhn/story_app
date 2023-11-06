import 'package:flutter/material.dart';
import 'package:story_app/api/api_service.dart';
import 'package:story_app/database/db.dart';
import 'package:story_app/localization/main.dart';
import 'package:story_app/main.dart';
import 'package:story_app/model/response/login_response.dart';
import 'package:story_app/model/response/register_response.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final DatabaseRepository _databaseRepository = DatabaseRepository();

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
        AppLocalizations.of(navigatorKey.currentContext!)!.success,
        response.message,
      );
      await _databaseRepository.insertToDB({
        'userId': response.loginResult.userId,
        'name': response.loginResult.name,
        'token': response.loginResult.token,
      });
      return _userToken = response.loginResult;
    } catch (e) {
      _isFetching = false;
      notifyListeners();
      // throw alert error
      showMyDialog(
        AppLocalizations.of(navigatorKey.currentContext!)!.error,
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
        AppLocalizations.of(navigatorKey.currentContext!)!.success,
        response.message,
      );
      return response;
    } catch (e) {
      _isFetching = false;
      notifyListeners();
      // throw alert error
      showMyDialog(
        AppLocalizations.of(navigatorKey.currentContext!)!.error,
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
      await _databaseRepository.delete();
      _userToken = null;
      notifyListeners();
      showMyDialog(
        AppLocalizations.of(navigatorKey.currentContext!)!.success,
        'Logout success',
      );
    } catch (e) {
      _isFetching = false;
      notifyListeners();
      // throw alert error
      showMyDialog(
        'Error',
        e.toString(),
      );
    } finally {
      _isFetching = false;
      notifyListeners();
    }
  }
}
