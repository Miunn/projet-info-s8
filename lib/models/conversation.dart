class Conversation {
  int? id;
  String? name;

  Conversation({this.id, this.name,});

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  Conversation.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
  }

  @override
  String toString() {
    return 'Conversation{id: $id, name: $name}';
  }
}
