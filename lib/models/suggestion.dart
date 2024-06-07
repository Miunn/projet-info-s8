import 'package:intl/intl.dart';

class Suggestion {
  int? id;
  String? message;
  String? user;
  DateTime? createdAt; // Timestamp

  Suggestion({
    this.id,
    this.message,
    this.user,
    this.createdAt,
  });

  Suggestion.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    message = map['message'];
    user = map['user'];
    final formatter = DateFormat('EEE, d MMM yyyy HH:mm:ss');
    createdAt = formatter.parse(map['created_at']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'message': message,
      'user': user,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Suggestion{id: $id, message: $message, user: $user, createdAt: $createdAt}';
  }
}