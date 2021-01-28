import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/models/exceptions.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String _token;
  String _userId;
  DateTime _expiryTime;

  bool get isAuth {
    return token != null;
  }

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
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }
}
