import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:myapp/enum/user_state.dart';
import 'package:myapp/helper/constants.dart';
import 'package:myapp/local_database/repository/log_repository.dart';
import 'package:myapp/provider/user_provider.dart';
import 'package:myapp/services/auth.dart';
import 'package:myapp/services/databases.dart';
import 'package:myapp/states/appbarcustom_home.dart';
import 'package:myapp/views/callscreens/pickup/pickup_layout.dart';
import 'package:myapp/views/chat_list_screen.dart';
import 'package:myapp/views/searchScreen.dart';
import 'package:provider/provider.dart';

import 'log_Screen/log_screen.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> with WidgetsBindingObserver {
  // FirebaseRepository
  // String currentUserId;
  databaseMethods database = new databaseMethods();
  PageController pageController;
  String Message = "Hello";
  Stream chatRoomStream;
  UserProvider userProvider;
  AuthMethods authMethods = AuthMethods();

  int _page = 0;
  double _labledontsize = 12;
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.refreshUser();

      authMethods.setUserState(
        userId: userProvider.getUser.uid,
        userState: UserState.Online,
      );

      LogRepository.init(
        isHive: true,
        dbName: userProvider.getUser.uid,
      );
    });

    WidgetsBinding.instance.addObserver(this);
    pageController = PageController();
  }

  void onPagechanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTaped(int page) {
    pageController.jumpToPage(page);
  }

  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        appBar: AppBar(
          title: UserCircle(),
          actions: <Widget>[
            IconButton(
              icon: Image.asset("assets/images/icon_cam.png"),
              onPressed: () {
                print("${Constants.MyName} This si myName");
                // ScaffoldMessenger.of(context).showSnackBar(
                //     const SnackBar(content: Text('This is a camera')));
              },
            ),
            IconButton(
              icon: Image.asset("assets/images/icon_edit.png"),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('This is a edit')));
              },
            )
          ],
        ),
        body: PageView(
          children: <Widget>[
            Center(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 70,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      // ignore: deprecated_member_use
                      child: FlatButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => searchScreen()));
                          },
                          color: Color(0x8AA19393),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.search),
                              Text(
                                "Tìm kiếm",
                              )
                            ],
                          )),
                    ),
                  ),
                  Expanded(child: ChatListScreen()),
                ],
              ),
            ),
            Center(child: LogScreen()),
          ],
          controller: pageController,
          onPageChanged: onPagechanged,
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
              border: Border(top: BorderSide(width: 1, color: Colors.blue))),
          height: 60,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 0),
            child: CupertinoTabBar(
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.chat,
                      color: (_page == 0) ? Colors.blue : Color(0xdfffffff),
                    ),
                    // ignore: deprecated_member_use
                    title: Text(
                      "Chats",
                      style: TextStyle(
                          fontSize: (_page == 0) ? _labledontsize : 10,
                          color:
                              (_page == 0) ? Colors.blue : Color(0xdfffffff)),
                    )),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.call,
                      color: (_page == 1) ? Colors.blue : Color(0xdfffffff),
                    ),
                    // ignore: deprecated_member_use
                    title: Text(
                      "Calls",
                      style: TextStyle(
                          fontSize: (_page == 1) ? _labledontsize : 10,
                          color:
                              (_page == 1) ? Colors.blue : Color(0xdfffffff)),
                    )),
              ],
              onTap: navigationTaped,
              currentIndex: _page,
            ),
          ),
        ),
      ),
    );
  }
}
