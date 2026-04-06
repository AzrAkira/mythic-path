class RewardModel {
  final String id;
  final String title;
  final String description;
  final int cost; // Harga barang dalam bentuk Gold
  final String icon; // Emoji untuk gambar barang

  RewardModel({
    required this.id,
    required this.title,
    required this.description,
    required this.cost,
    required this.icon,
  });

  // Siapa tahu nanti kamu mau membuat fitur "Edit Reward"
  RewardModel copyWith({
    String? id,
    String? title,
    String? description,
    int? cost,
    String? icon,
  }) {
    return RewardModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      cost: cost ?? this.cost,
      icon: icon ?? this.icon,
    );
  }
}
