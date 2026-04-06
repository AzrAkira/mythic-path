class UserModel {
  // 1. Menggunakan 'final' agar data tidak berubah di luar kontrol (Immutability)
  final String id;
  final String username;
  final int currentLevel;
  final int currentXp; // XP untuk level saat ini
  final int lifetimeXp; // Total keseluruhan XP (untuk leaderboard)
  final int gold;
  final String classType;
  final DateTime? createdAt; // Waktu pembuatan akun

  UserModel({
    required this.id,
    required this.username,
    this.currentLevel = 1,
    this.currentXp = 0,
    this.lifetimeXp = 0,
    this.gold = 0,
    this.classType = 'Novice',
    this.createdAt,
  });

  // 2. Fungsi copyWith untuk memanipulasi data tanpa merusak objek aslinya
  UserModel copyWith({
    String? id,
    String? username,
    int? currentLevel,
    int? currentXp,
    int? lifetimeXp,
    int? gold,
    String? classType,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      currentLevel: currentLevel ?? this.currentLevel,
      currentXp: currentXp ?? this.currentXp,
      lifetimeXp: lifetimeXp ?? this.lifetimeXp,
      gold: gold ?? this.gold,
      classType: classType ?? this.classType,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  int get xpRequiredForNextLevel {
    return 100 + ((currentLevel - 1) * 100);
  }

  // 3. Logika Add Reward tidak lagi memodifikasi object ini langsung (karena final),
  // melainkan mengembalikan Object User yang baru.
  UserModel addReward(int xpGained, int goldGained) {
    int newLifetimeXp = lifetimeXp + xpGained;
    int newCurrentXp = currentXp + xpGained;
    int newCurrentLevel = currentLevel;
    int newGold = gold + goldGained;
    int requirement = 100 + ((newCurrentLevel - 1) * 100);

    while (newCurrentXp >= requirement) {
      newCurrentXp -= requirement;
      newCurrentLevel++;
      requirement =
          100 +
          ((newCurrentLevel - 1) *
              100); // Update XP yang dibutuhkan untuk level berikutnya
      print(
        "Selamat! $username naik ke Level $newCurrentLevel. Butuh $requirement XP untuk level selanjutnya.",
      );
    }

    // Mengembalikan data user yang sudah di-update
    return copyWith(
      currentXp: newCurrentXp,
      lifetimeXp: newLifetimeXp,
      currentLevel: newCurrentLevel,
      gold: newGold,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'currentLevel': currentLevel,
      'currentXp': currentXp,
      'lifetimeXp': lifetimeXp,
      'gold': gold,
      'classType': classType,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      username: map['username'],
      currentLevel: map['currentLevel'] ?? 1,
      currentXp: map['currentXp'] ?? 0,
      lifetimeXp: map['lifetimeXp'] ?? 0,
      gold: map['gold'] ?? 0,
      classType: map['classType'] ?? 'Novice',
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : null,
    );
  }
}
