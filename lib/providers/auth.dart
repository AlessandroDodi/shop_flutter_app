import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_flutter_app/models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;

  bool get isAuth {
    return _token != null;
  }

  String get userId {
    return _userId ?? "";
  }

  String? get token {
    if (_expiryDate != null && _expiryDate!.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }
  Future<void> logout() async {
    _token = null;
    _expiryDate = null;
    _userId = null;
    if(_authTimer != null) {
    _authTimer?.cancel();
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
}
void _autoLogout() {
  if(_authTimer != null )  {
    _authTimer?.cancel();
  }
  final time = _expiryDate?.difference(DateTime.now()).inSeconds;
  _authTimer =  Timer(Duration(seconds:time ?? 0), logout);
  notifyListeners();
}

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        Uri.parse('$urlSegment?key=AIzaSyAVcGADFolGpajOuFhvvIqHjcjazkkHjFw');
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      if (json.decode(response.body)['error'] != null) {
        throw HttpException(json.decode(response.body)['error']['message']);
      }
      _token = json.decode(response.body)['idToken'];

      _userId = json.decode(response.body)['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            json.decode(response.body)['expiresIn'],
          ),
        ),
      );
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({'token': _token, 'userId': _userId, 'expiryDate': _expiryDate?.toIso8601String()});
      prefs.setString('userData', userData);
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }
  Future<bool> tryAutoLogin2() async {
    print('va');
    
    final prefs = await SharedPreferences.getInstance();
    print(prefs.containsKey('userData'));
    if (!prefs.containsKey('userData')) {
      print('qui?');
      
      return false;
    }
    final extractedUserData = json.decode(prefs.getString('userData') ?? '') as Map<String, Object>;
    print("userdata: $extractedUserData");
    //if(extractedUserData['e"xpiryDate'] == null) return false;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate'].toString());
    if(expiryDate.isBefore(DateTime.now())) {
      notifyListeners();
      return false;
    }
    _token = extractedUserData['token'].toString();
    _userId = extractedUserData['userId'].toString();
    _expiryDate = expiryDate;
    _autoLogout();
    return true;
  }
    Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final temp = prefs.getString('userData');
    if(temp == null) {
      return false;
    }
    final extractedUserData = json.decode(temp) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate'].toString());

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'].toString();
    _userId = extractedUserData['userId'].toString();
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password,
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp');
  }

  Future<void> signin(String email, String password) async {
    return _authenticate(email, password,
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword');
  }
}
