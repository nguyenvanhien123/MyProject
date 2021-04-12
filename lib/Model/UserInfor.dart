class UserInfor {
  String uid;
  String name;
  String email;
  String username;
  String status;
  int state;
  String profilePhoto;

  UserInfor({
    this.uid,
    this.name,
    this.email,
    this.username,
    this.status,
    this.state,
    this.profilePhoto,
  });

  Map toMap(UserInfor userInfor) {
    var data = Map<String, dynamic>();
    data['uid'] = userInfor.uid;
    data['name'] = userInfor.name;
    data['email'] = userInfor.email;
    data['username'] = userInfor.username;
    data["status"] = userInfor.status;
    data["state"] = userInfor.state;
    data["profile_photo"] = userInfor.profilePhoto;
    return data;
  }

  // Named constructor
  UserInfor.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['uid'];
    this.name = mapData['name'];
    this.email = mapData['email'];
    this.username = mapData['username'];
    this.status = mapData['status'];
    this.state = mapData['state'];
    this.profilePhoto = mapData['profile_photo'];
  }
}
