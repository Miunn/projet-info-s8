class Chat {
  int? id;
  String? message;
  bool? isMe;
  bool? ratedGood;
  bool? ratedBad;
  int? conversationId;
  DateTime? sentAt;

  Chat({this.id, this.message, this.isMe, this.ratedGood, this.ratedBad, this.conversationId, this.sentAt});

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'message': message,
      'isMe': (isMe ?? false) ? 1 : 0,
      'ratedGood': (ratedGood ?? false) ? 1 : 0,
      'ratedBad': (ratedBad ?? false) ? 1 : 0,
      'conversationId': conversationId,
      'sentAt': sentAt?.toIso8601String(),
    };
  }

  Chat.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    message = map['message'];
    isMe = map['isMe'] == 1;
    ratedGood = map['ratedGood'] == 1;
    ratedBad = map['ratedBad'] == 1;
    conversationId = map['conversationId'];
    sentAt = DateTime.parse(map['sentAt']);
  }

  Map<String, Object?> toApi() {
    return {
      'role': (isMe ?? true) ? 'user' : 'assistant',
      'content': message ?? '',
    };
  }

  @override
  String toString() {
    return 'Chat{id: $id, message: $message, isMe: $isMe, ratedGood: $ratedGood, ratedBad: $ratedBad, conversationId: $conversationId, sentAt: $sentAt}';
  }
}