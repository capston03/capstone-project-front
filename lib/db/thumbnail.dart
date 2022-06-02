class ThumbNail {
  late String title;
  late String content;
  late String uploader_gmail_id;
  late String upload_time;
  late String beacon_mac;
  late int identifier;
  late int heart_rate;

  ThumbNail(
      {required this.title, required this.content, required this.uploader_gmail_id,
      required this.upload_time, required this.beacon_mac, required this.identifier,
      required this.heart_rate});

  factory ThumbNail.fromMap(Map<String, dynamic> json) {
    return ThumbNail(title: json['title'],content: json['content'], uploader_gmail_id: json['uploader_gmail_id'],
    upload_time: json['upload_time'],beacon_mac: json['beacon_mac'],identifier: json['identifier'],heart_rate: json['heart_rate']);
  }

  Map<String, dynamic> toMap() {
    return {
      'title':title,
      'content':content,
      'beacon_mac':beacon_mac,
      'upload_time':upload_time,
      'uploader_gmail_id':uploader_gmail_id,
      'heart_rate':heart_rate,
      'identifier':identifier,
    };
  }

  @override
  String toString(){
    return 'ThumbNail{title:$title content:$content, beacon_mac:$beacon_mac, upload_time:$upload_time, uploader_gmail_id:$uploader_gmail_id, heart_rate:$heart_rate,identifier:$identifier}';
  }
}
