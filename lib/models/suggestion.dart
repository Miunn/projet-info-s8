class Suggestions {
  int? id;
  String? message;
  String? user;
  int? createdAt; // Timestamp

  Suggestions({
    this.id,
    this.message,
    this.user,
    this.createdAt,
  });

  Suggestions.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    message = map['message'];
    user = map['user'];
    createdAt = map['created_at'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'message': message,
      'user': user,
      'created_at': createdAt,
    };
  }

  @override
  String toString() {
    return 'Suggestion{id: $id, message: $message, user: $user, createdAt: $createdAt}';
  }
}