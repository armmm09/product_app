
import 'package:flutter/material.dart';

class LoginModel with ChangeNotifier { //Ketika Anda menggunakan with ChangeNotifier dalam sebuah kelas, Anda mengindikasikan bahwa kelas tersebut mengimplementasikan fungsionalitas 
  bool validateCredentials(String? email, String? password) {
    if (email == 'admin@gmail.com' && password == '12345') {
      return true; 
    }
    return false; // Gunakan return true and false agar codingan ini mau berjalan
  }
}
