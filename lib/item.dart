class Item {
  final String id;
  final String name;
  final String description;

  Item({
    required this.id,
    required this.name,
    required this.description,
  });

  // Convierte un objeto Item a un Map para enviarlo a Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }

  // Crea un objeto Item a partir de un Map proveniente de Firestore
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Sin nombre',
      description: json['description'] as String? ?? 'Sin descripción',
    );
  }
}
