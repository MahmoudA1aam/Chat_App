
class MessageModel {
  String content;
  int dateTime;
  String email;
  String senderName;

  MessageModel(
      {required this.content,
        required this.email,
        required this.dateTime,
        required this.senderName});

  factory MessageModel.fromFireStore(Map<String, dynamic> json) {
    return MessageModel(
      senderName: json["senderName"],
      email: json["email"],
      dateTime: json["dateTime"],
      content: json["content"],
    );
  }

  Map<String, dynamic> toFireStore() {
    return {
      "senderName": senderName,
      "dateTime": dateTime,
      "email": email,
      "content": content,
    };
  }
}