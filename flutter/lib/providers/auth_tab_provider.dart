import 'package:flutter/material.dart';

class AuthTabProvider with ChangeNotifier {
  bool isLogin = true;

  void toggle() {
    isLogin = !isLogin;
    notifyListeners();
  }

  void setLogin() {
    isLogin = true;
    notifyListeners();
  }

  void setCadastro() {
    isLogin = false;
    notifyListeners();
  }
}
