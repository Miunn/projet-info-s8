import 'package:intl/intl.dart';

class Suggestion {
  int? id;              // Identifiant unique de la suggestion
  String? message;      // Contenu de la suggestion
  String? user;         // Auteur de la suggestion
  DateTime? createdAt;  // Date de création de la suggestion (format timestamp)
  bool? upVoted;        // Indique si la suggestion a été upvotée

  // Constructeur, aucun paramètre requis
  Suggestion({
    this.id,
    this.message,
    this.user,
    this.createdAt,
    this.upVoted,
  });

  // Constructeur à partir d'une map
  Suggestion.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    message = map['message'];
    user = map['user'];
    final formatter = DateFormat('EEE, d MMM yyyy HH:mm:ss');
    createdAt = formatter.parse(map['created_at']);
    upVoted = map['upvoted'] == 1;
  }

  // Transforme l'objet en map adaptable en JSON
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'message': message,
      'user': user,
      'created_at': createdAt?.toIso8601String(),
      'upVoted': (upVoted ?? false) ? 1 : 0,
    };
  }

  // Affichage de l'objet sous forme de chaîne de caractères
  @override
  String toString() {
    return 'Suggestion{id: $id, message: $message, user: $user, createdAt: $createdAt, upVoted: $upVoted}';
  }
}