import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import 'shared_prefs_provider.dart';

class UserNotifier extends Notifier<UserModel> {
  @override
  UserModel build() {
    final prefs = ref.watch(sharedPrefsProvider);

    return UserModel(
      id: 'u_001',
      // 👇 Load nama dari memori. Kalau kosong, beri default 'Pahlawan Baru'
      username: prefs.getString('username') ?? 'Pahlawan Baru',
      currentLevel: prefs.getInt('level') ?? 1,
      currentXp: prefs.getInt('xp') ?? 0,
      gold: prefs.getInt('gold') ?? 0,
      classType: prefs.getString('classType') ?? 'Novice',
    );
  }

  void gainReward(int xpGained, int goldGained) {
    state = state.addReward(xpGained, goldGained);
    _saveToMemory();
  }

  bool spendGold(int cost) {
    if (state.gold >= cost) {
      state = state.copyWith(gold: state.gold - cost);
      _saveToMemory();
      return true;
    }
    return false;
  }

  void changeClass(String newClass) {
    state = state.copyWith(classType: newClass);
    _saveToMemory();
  }

  // --- ✍️ FUNGSI BARU: GANTI NAMA ---
  void changeUsername(String newName) {
    state = state.copyWith(username: newName);
    _saveToMemory(); // Simpan nama baru ke memori!
  }

  void _saveToMemory() {
    final prefs = ref.read(sharedPrefsProvider);
    prefs.setInt('level', state.currentLevel);
    prefs.setInt('xp', state.currentXp);
    prefs.setInt('gold', state.gold);
    prefs.setString('classType', state.classType);
    prefs.setString('username', state.username); // <- Simpan nama karakter
  }
}

final userProvider = NotifierProvider<UserNotifier, UserModel>(
  UserNotifier.new,
);
