import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_flutter_app/models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;

  bool get isAuth {
    return _token != null;
  }

  String get userId {
    return _userId ?? "";
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != "") {
      print('mi sa che non entra qui');
      return _token;
    }
    return null;
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
      //print(json.decode(response.body));
      _token = json.decode(response.body)['idToken'];

      _userId = json.decode(response.body)['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            json.decode(response.body)['expiresIn'],
          ),
        ),
      );
      print(_token);
      print("--------------------------------");
      print(_userId);
      print("--------------------------------");
      print(_expiryDate);
    } catch (e) {
      throw e;
    }
    notifyListeners();
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
