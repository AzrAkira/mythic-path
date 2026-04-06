import 'package:flutter/material.dart';
import '../models/quest_model.dart';

// Ubah menjadi StatelessWidget biasa karena datanya sudah diurus Riverpod
class QuestCardWidget extends StatelessWidget {
  final QuestModel quest;
  final VoidCallback onComplete;

  const QuestCardWidget({
    super.key,
    required this.quest,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 0, // Dibuat 0 agar desain modern pastelmu makin menonjol
      color: Colors.grey[50], // Sedikit warna background agar beda dengan layar
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              quest.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                // Mengambil nilai isCompleted langsung dari model quest!
                decoration: quest.isCompleted
                    ? TextDecoration.lineThrough
                    : null,
                color: quest.isCompleted
                    ? Colors.grey
                    : Colors.black, // Teks jadi abu-abu kalau selesai
              ),
            ),
            const SizedBox(height: 5),
            Text(quest.description, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      '🔹 ${quest.rewardXp} XP',
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Text(
                      '🪙 ${quest.rewardGold} Gold',
                      style: const TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: quest.isCompleted
                        ? Colors.grey[300]
                        : Colors.green,
                    foregroundColor: quest.isCompleted
                        ? Colors.grey[600]
                        : Colors.white,
                    elevation: quest.isCompleted
                        ? 0
                        : 2, // Hilangkan bayangan kalau sudah selesai
                  ),
                  // Tombol mati (null) kalau sudah selesai
                  onPressed: quest.isCompleted ? null : onComplete,
                  child: Text(quest.isCompleted ? 'Selesai' : 'Kerjakan'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
