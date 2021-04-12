import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/Model/UserInfor.dart';
import 'package:myapp/services/databases.dart';

class FirebaseRepository {
  databaseMethods methods = databaseMethods();
  Future<List<UserInfor>> fetchAllUsers(User user) =>
      methods.fetchAllUsers(user);
  Future<User> getCurrentUser() => methods.getCurrentUser();
}
