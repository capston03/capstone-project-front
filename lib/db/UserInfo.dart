class UserInfo {
  late final String googleID;
  late final String nick;
  late final DateTime imageUpload;

  UserInfo(
      {required this.googleID, required this.nick, required this.imageUpload});

  factory UserInfo.fromMap(Map<String, dynamic> json) {
   return UserInfo(googleID: json['googleID'], nick: json['nick'], imageUpload: json['imageUpload']);
 }

  Map<String, dynamic> toMap() {
    return {'googleID': googleID, 'nick': nick, 'imageUpload': imageUpload};
  }

  @override
  String toString(){
    return 'UserInfo{googleID: $googleID, nick: $nick, imageUpload: $imageUpload}';
  }
}
