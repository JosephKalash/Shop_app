import 'dart:async';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/models/exceptions.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  String _userId;
  DateTime _expiryTime;
  Timer _authTimer;

  String get userId => _userId;

  bool get isAuth => token != null;

  String get token {
    if (_token != null && _expiryTime != null && _expiryTime.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  Future<void> _authenticate(String email, String password, String urlSegment) async {
    final url = 'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyCu6uIsMB9ztDwjg2egyfvWAOtVBnbyX70';

    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));

      final decodedResponse = jsonDecode(response.body);

      if (decodedResponse['error'] != null) {
        throw HttpException(decodedResponse['error']['message']);
      }

      _token = decodedResponse['idToken'];
      _userId = decodedResponse['localId'];
      _expiryTime = DateTime.now().add(
        Duration(seconds: int.parse(decodedResponse['expiresIn'])),
      );

      notifyListeners();
      _autoLogoutTimer();

      ///save auth info in device storage for auto login.
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryTime': _expiryTime.toIso8601String(),
      });
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }

    final authData = json.decode(prefs.getString('userData')) as Map<String, Object>;
    _expiryTime = DateTime.parse(authData['expiryTime']);

    if (_expiryTime.isBefore(DateTime.now())) {
      return false;
    }
    _userId = authData['userId'];
    _token = authData['token'];

    notifyListeners();

    _autoLogoutTimer();

    return true;
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> logout() async {
    _userId = _token = _expiryTime = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    //prefs.remove('authDate');
    prefs.clear();
  }

  void _autoLogoutTimer() {
    if (_authTimer != null) {
      _authTimer = null;
    }
    final timeToExpiry = _expiryTime.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
