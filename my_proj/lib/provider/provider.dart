import 'package:flutter/cupertino.dart';

class LoginDataProvider with ChangeNotifier{

  int _userid = 0;
  String _username = '';
  String _email = '';
  String _password = '';

  int get userId => _userid;
  String get username => _username;
  String get email => _email;
  String get password => _password;

  void setData(int userId, String username, String email, String password){
    _userid = userId;
    _username = username;
    _email = email;
    _password = password;
    notifyListeners();

  }

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }
}