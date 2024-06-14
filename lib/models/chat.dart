class Chat {
  int? id;                // Identifiant unique du message
  String? message;        // Contenu du message
  bool? isMe;             // Indique si le message a été envoyé par l'utilisateur
  bool? ratedGood;        // Indique si le message a été noté positivement
  bool? ratedBad;         // Indique si le message a été noté négativement
  int? conversationId;    // Identifiant de la conversation à laquelle appartient le message
  DateTime? sentAt;       // Date d'envoi du message

  // Constructeur, aucun paramètre requis
  Chat({this.id, this.message, this.isMe, this.ratedGood, this.ratedBad, this.conversationId, this.sentAt});

  // Transforme l'objet en map adaptable en JSON
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

  // Constructeur à partir d'une map
  Chat.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    message = map['message'];
    isMe = map['isMe'] == 1;
    ratedGood = map['ratedGood'] == 1;
    ratedBad = map['ratedBad'] == 1;
    conversationId = map['conversationId'];
    sentAt = DateTime.parse(map['sentAt']);
  }

  // Format de dictionnaire à envoyer à l'API
  Map<String, Object?> toApi() {
    return {
      'role': (isMe ?? true) ? 'user' : 'assistant',
      'content': message ?? '',
    };
  }

  // Affichage de l'objet sous forme de chaîne de caractères
  @override
  String toString() {
    return 'Chat{id: $id, message: $message, isMe: $isMe, ratedGood: $ratedGood, ratedBad: $ratedBad, conversationId: $conversationId, sentAt: $sentAt}';
  }
}