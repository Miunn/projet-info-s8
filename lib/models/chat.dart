class Chat {
  int? id;
  String? message;
  bool? isMe;
  String? conversationId;
  String? sentAt;

  Chat({this.id, this.message, this.isMe, this.conversationId, this.sentAt});

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'message': message,
      'isMe': isMe,
      'conversationId': conversationId,
      'sentAt': sentAt,
    };
  }

  Chat.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    message = map['message'];
    isMe = map['isMe'];
    conversationId = map['conversationId'];
    sentAt = map['sentAt'];
  }

  @override
  String toString() {
    return 'Chat{id: $id, message: $message, isMe: $isMe, conversationId: $conversationId, sentAt: $sentAt}';
  }
}