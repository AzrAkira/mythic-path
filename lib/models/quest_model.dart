class QuestModel {
  final String id;
  final String title;
  final String description;
  final int rewardXp;
  final int rewardGold;
  final bool isCompleted;
  final String? url;

  QuestModel({
    required this.id,
    required this.title,
    required this.description,
    required this.rewardXp,
    required this.rewardGold,
    this.isCompleted = false,
    this.url,
  });

  QuestModel copyWith({
    String? id,
    String? title,
    String? description,
    int? rewardXp,
    int? rewardGold,
    bool? isCompleted,
  }) {
    return QuestModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      rewardXp: rewardXp ?? this.rewardXp,
      rewardGold: rewardGold ?? this.rewardGold,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  // --- TAMBAHAN BARU UNTUK SAVE/LOAD ---

  // 1. Mengubah Objek menjadi bentuk Map (Kamus) agar bisa jadi JSON
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'rewardXp': rewardXp,
      'rewardGold': rewardGold,
      'isCompleted': isCompleted,
    };
  }

  // 2. Membaca format Map (Kamus) menjadi Objek QuestModel lagi
  factory QuestModel.fromMap(Map<String, dynamic> map) {
    return QuestModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      rewardXp: map['rewardXp'] ?? 0,
      rewardGold: map['rewardGold'] ?? 0,
      isCompleted: map['isCompleted'] ?? false,
    );
  }
}
