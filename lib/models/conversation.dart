class Conversation {
  int? id;        // Identifiant unique de la conversation
  String? name;   // Nom de la conversation

  // Constructeur, aucun paramètre requis
  Conversation({this.id, this.name,});

  // Transforme l'objet en map adaptable en JSON
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  // Constructeur à partir d'une map
  Conversation.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
  }

  // Format de dictionnaire à envoyer à l'API
  @override
  String toString() {
    return 'Conversation{id: $id, name: $name}';
  }
}
