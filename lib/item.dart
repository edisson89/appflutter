// Modelo de datos simple para almacenar la informacion
class Item {
  final int id;
  final String name;
  final String description;

  Item({
    required this.id,
    required this.name,
    required this.description,
  });

  // Convertir un objeto Item a un Map (para JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }

  // Crear un objeto Item desde un Map (desde JSON)
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }

}