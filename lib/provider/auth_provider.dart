import 'package:flutter/material.dart';
import 'package:story_app/api/api_service.dart';
import 'package:story_app/database/db.dart';
import 'package:story_app/main.dart';
import 'package:story_app/model/response/login_response.dart';
import 'package:story_app/model/response/register_response.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final DatabaseRepository _databaseRepository = DatabaseRepository();

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
      showMyDialog(
        'Success',
        response.message,
      );
      await _databaseRepository.insertToDB({
        'userId': response.loginResult.userId,
        'name': response.loginResult.name,
        'token': response.loginResult.token,
      });
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

  Future<RegisterResponse> register(
      String name, String email, String password) async {
    try {
      setIsFetching(true);
      var response = await _apiService.register(name, email, password);
      // set user token
      notifyListeners();
      showMyDialog(
        'Success',
        response.message,
      );
      return response;
    } catch (e) {
      setIsFetching(false);
      notifyListeners();
      // throw alert error
      showMyDialog(
        'Error',
        e.toString(),
      );
      return RegisterResponse(
        error: true,
        message: e.toString(),
      );
    } finally {
      setIsFetching(false);
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      setIsFetching(true);
      await _databaseRepository.delete();
      _userToken = null;
      notifyListeners();
      showMyDialog(
        'Success',
        'Logout success',
      );
    } catch (e) {
      setIsFetching(false);
      notifyListeners();
      // throw alert error
      showMyDialog(
        'Error',
        e.toString(),
      );
    } finally {
      setIsFetching(false);
      notifyListeners();
    }
  }
}
