class UserModel{
  late final String user_gmail_id;
  late final String android_id;
  late final String device_model;
  late final String gmail_id;

  UserModel({required this.user_gmail_id, required this.android_id, required this.device_model, required this.gmail_id});
  factory UserModel.fromMap(Map<String, dynamic> json) {
    return UserModel(user_gmail_id: json['user_gmail_id'], android_id: json['android_id'], device_model: json['device_model'],gmail_id:json['gmail_id']);
  }
  Map<String, dynamic> toMap() {
    return {'user_gmail_id': user_gmail_id, 'android_id': android_id, 'device_model': device_model,'gmail_id':gmail_id};
  }
}