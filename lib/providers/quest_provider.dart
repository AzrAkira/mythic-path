import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/quest_model.dart';
import 'shared_prefs_provider.dart';

class QuestNotifier extends Notifier<List<QuestModel>> {
  @override
  List<QuestModel> build() {
    final prefs = ref.watch(sharedPrefsProvider);
    final questsJson = prefs.getStringList('quests_data');

    List<QuestModel> loadedQuests = [];

    // 1. [LOAD GAME]: Muat data dari brankas memori jika ada
    if (questsJson != null) {
      loadedQuests = questsJson.map((jsonStr) {
        return QuestModel.fromMap(jsonDecode(jsonStr));
      }).toList();
    } else {
      // Jika kosong (baru pertama kali main), berikan misi Dummy
      loadedQuests = [
        QuestModel(
          id: 'q1',
          title: 'Ramuan Kesegaran',
          description: 'Minum 2 gelas air putih pagi ini.',
          rewardXp: 50,
          rewardGold: 10,
        ),
        QuestModel(
          id: 'q2',
          title: 'Pengetahuan Kuno',
          description: 'Membaca buku atau materi kuliah selama 20 menit.',
          rewardXp: 150,
          rewardGold: 30,
        ),
        QuestModel(
          id: 'q3',
          title: 'Kerapian Markas',
          description: 'Rapikan tempat tidur dan meja belajar.',
          rewardXp: 100,
          rewardGold: 15,
        ),
      ];
    }

    // --- 🕒 FITUR RESET HARIAN OTOMATIS 🕒 ---

    // Ambil tanggal hari ini dengan format Tahun-Bulan-Tanggal (Contoh: 2026-3-2)
    final now = DateTime.now();
    final todayString = "${now.year}-${now.month}-${now.day}";

    // Cek kapan terakhir kali quest di-reset
    final lastResetDate = prefs.getString('last_reset_date');

    // Jika hari sudah berganti (tanggal tidak sama)
    if (lastResetDate != todayString) {
      // Sapu bersih! Ubah semua isCompleted jadi false (Kembali jadi tombol "Kerjakan")
      loadedQuests = loadedQuests.map((quest) {
        return quest.copyWith(isCompleted: false);
      }).toList();

      // Update catatannya agar tidak di-reset lagi di hari yang sama
      prefs.setString('last_reset_date', todayString);

      // Simpan kondisi misi yang sudah segar ini ke Memory Card
      final resetQuestsJson = loadedQuests
          .map((q) => jsonEncode(q.toMap()))
          .toList();
      prefs.setStringList('quests_data', resetQuestsJson);

      print("Misi harian berhasil di-reset untuk tanggal: $todayString");
    }

    // Kembalikan daftar misi yang sudah siap ke layar
    return loadedQuests;
  }

  // Fungsi untuk mengubah status quest menjadi selesai
  void completeQuest(String questId) {
    state = state.map((quest) {
      if (quest.id == questId) {
        return quest.copyWith(isCompleted: true);
      }
      return quest;
    }).toList();

    _saveToMemory();
  }

  // Fungsi untuk menambah misi baru buatan pemain
  void addQuest(QuestModel newQuest) {
    state = [...state, newQuest];
    _saveToMemory();
  }

  void deleteQuest(String questId) {
    state = state.where((quest) => quest.id != questId).toList();
    _saveToMemory();
  }

  // --- FUNGSI RAHASIA UNTUK AUTO SAVE ---
  void _saveToMemory() {
    final prefs = ref.read(sharedPrefsProvider);
    final questsJson = state.map((quest) => jsonEncode(quest.toMap())).toList();
    prefs.setStringList('quests_data', questsJson);
  }
}

final questProvider = NotifierProvider<QuestNotifier, List<QuestModel>>(
  QuestNotifier.new,
);
