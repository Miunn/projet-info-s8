class Chat {
  int? id;
  String? message;
  bool? isMe;
  int? conversationId;
  DateTime? sentAt;

  Chat({this.id, this.message, this.isMe, this.conversationId, this.sentAt});

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'message': message,
      'isMe': (isMe ?? false) ? 1 : 0,
      'conversationId': conversationId,
      'sentAt': sentAt?.toIso8601String(),
    };
  }

  Chat.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    message = map['message'];
    isMe = map['isMe'] == 1 ? true : false;
    conversationId = map['conversationId'];
    sentAt = DateTime.parse(map['sentAt']);
  }

  @override
  String toString() {
    return 'Chat{id: $id, message: $message, isMe: $isMe, conversationId: $conversationId, sentAt: $sentAt}';
  }
}