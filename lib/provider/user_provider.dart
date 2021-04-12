import 'package:flutter/widgets.dart';
import 'package:myapp/Model/UserInfor.dart';
import 'package:myapp/services/databases.dart';

class UserProvider with ChangeNotifier {
  UserInfor _user;
  databaseMethods _databasemethod = databaseMethods();

  UserInfor get getUser => _user;

  Future<void> refreshUser() async {
    UserInfor user = await _databasemethod.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
