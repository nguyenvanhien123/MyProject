import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/Model/UserInfor.dart';
import 'package:myapp/services/Firebase_repository.dart';
import 'package:myapp/utils/universal_variables.dart';
import 'package:myapp/views/conversation_screen.dart';
import 'package:myapp/widgets/cached_image.dart';
import 'package:myapp/widgets/custom_tile.dart';

class searchScreen extends StatefulWidget {
  @override
  _searchScreenState createState() => _searchScreenState();
}

class _searchScreenState extends State<searchScreen> {
  QuerySnapshot searchSnapshot;
  FirebaseRepository _repository = FirebaseRepository();
  TextEditingController _SearchControllerm = new TextEditingController();
  List<UserInfor> userList;
  String query = "";
  @override
  void initState() {
    super.initState();

    _repository.getCurrentUser().then((User user) {
      _repository.fetchAllUsers(user).then((List<UserInfor> list) {
        setState(() {
          userList = list;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                height: 40,
                child: TextField(
                  onChanged: (val) {
                    setState(() {
                      query = val;
                    });
                  },
                  onEditingComplete: () {
                    // initiateSearch();
                  },
                  controller: _SearchControllerm,
                  autofocus: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Tìm Kiếm",
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                WidgetsBinding.instance
                    .addPostFrameCallback((_) => _SearchControllerm.clear());
              },
              icon: Icon(
                Icons.close,
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
      body: Container(child: buildSuggestions(query)),
    );
  }

  buildSuggestions(String query) {
    final List<UserInfor> suggestionList = query.isEmpty
        ? []
        : userList != null
            ? userList.where((UserInfor user) {
                String _getUsername = user.username.toLowerCase();
                String _query = query.toLowerCase();
                String _getName = user.name.toLowerCase();
                bool matchesUsername = _getUsername.contains(_query);
                bool matchesName = _getName.contains(_query);

                return (matchesUsername || matchesName);

                // (User user) => (user.username.toLowerCase().contains(query.toLowerCase()) ||
                //     (user.name.toLowerCase().contains(query.toLowerCase()))),
              }).toList()
            : [];

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: ((context, index) {
        UserInfor searchedUser = UserInfor(
            uid: suggestionList[index].uid,
            profilePhoto: suggestionList[index].profilePhoto,
            name: suggestionList[index].name,
            username: suggestionList[index].username);

        return CustomTile(
          mini: false,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Conversation(
                          receiver: searchedUser,
                        )));
          },
          leading: Padding(
            padding: const EdgeInsets.only(left: 2),
            child: CachedImage(
              searchedUser.profilePhoto,
              radius: 40,
              isRound: true,
            ),
          ),
          // leading: CircleAvatar(
          //   backgroundImage: NetworkImage(searchedUser.profilePhoto),
          //   backgroundColor: Colors.grey,
          // ),
          title: Text(
            searchedUser.username,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            searchedUser.name,
            style: TextStyle(color: UniversalVariables.greyColor),
          ),
        );
      }),
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
