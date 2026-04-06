class InventoryModel {
  final String id;
  final String title;
  final String description;
  final String icon;
  final int quantity; // Berapa banyak barang ini yang kamu miliki?

  InventoryModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.quantity,
  });

  // Jurus Copy untuk mengubah jumlah barang (ditambah/dikurangi)
  InventoryModel copyWith({
    String? id,
    String? title,
    String? description,
    String? icon,
    int? quantity,
  }) {
    return InventoryModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      quantity: quantity ?? this.quantity,
    );
  }

  // --- JURUS AUTO-SAVE KE MEMORY CARD ---
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': icon,
      'quantity': quantity,
    };
  }

  factory InventoryModel.fromMap(Map<String, dynamic> map) {
    return InventoryModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      icon: map['icon'] ?? '',
      quantity: map['quantity']?.toInt() ?? 1,
    );
  }
}
