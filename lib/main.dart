import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myapp/helper/authenicate.dart';
import 'package:myapp/helper/helperFutions.dart';
import 'package:myapp/provider/image_upload_provider.dart';
import 'package:myapp/provider/user_provider.dart';
import 'package:myapp/services/databases.dart';
import 'package:myapp/views/chatRoomsScreen.dart';
import 'package:myapp/views/searchScreen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Myapp());
}

class Myapp extends StatefulWidget {
  @override
  _MyappState createState() => _MyappState();
}

class _MyappState extends State<Myapp> {
  final databaseMethods _datbasemethod = databaseMethods();
  bool isLoggedIn;
  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await helperFunctions.getuserLoggedInSharePreference().then((value) {
      setState(() {
        isLoggedIn = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ImageUploadProvider()),
          ChangeNotifierProvider(create: (_) => UserProvider()),
        ],
        child: MaterialApp(
          title: "Skype Clone",
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: {
            '/search_screen': (context) => searchScreen(),
          },
          theme: ThemeData(
              brightness: Brightness.dark,
              visualDensity: VisualDensity.adaptivePlatformDensity),
          home: FutureBuilder(
            future: _datbasemethod.getCurrentUser(),
            builder: (context, AsyncSnapshot<User> snapshot) {
              if (snapshot.hasData) {
                return ChatRoom();
              } else {
                return Authenicate();
              }
            },
          ),
        ));
  }
}
