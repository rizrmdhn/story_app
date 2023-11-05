import 'package:flutter/material.dart';
import 'package:story_app/api/api_service.dart';
import 'package:story_app/main.dart';
import 'package:story_app/model/response/login_response.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  LoginResult? _userToken;
  bool _isFetching = false;
  bool _isLogin = false;

  bool get isLogin => _isLogin;
  bool get isFetching => _isFetching;

  LoginResult? get userToken => _userToken;

  void setIsLogin(bool isLogin) {
    _isLogin = isLogin;
    notifyListeners();
  }

  void setIsFetching(bool isFetching) {
    _isFetching = isFetching;
    notifyListeners();
  }

  Future<LoginResult?> login(String email, String password) async {
    try {
      setIsFetching(true);
      var response = await _apiService.login(email, password);
      // set user token
      notifyListeners();
      return _userToken = response.loginResult;
    } catch (e) {
      setIsFetching(false);
      notifyListeners();
      // throw alert error
      showMyDialog(
        'Error',
        e.toString(),
      );
      return _userToken = null;
    } finally {
      setIsFetching(false);
      notifyListeners();
    }
  }
}
