import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_provider.dart';
import '../widgets/quest_card_widget.dart';
import '../providers/quest_provider.dart';
import '../models/quest_model.dart';
import 'shop_screen.dart';
import 'inventory_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  String _getAvatarIcon(String classType, int level) {
    if (level >= 100) return '👑';
    switch (classType.toLowerCase()) {
      case 'warrior':
        return '🛡️';
      case 'mage':
        return '🧙‍♂️';
      case 'rogue':
        return '🥷';
      default:
        return '🧑‍🎓';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    int xpRequired = user.xpRequiredForNextLevel;
    double progress = user.currentXp / xpRequired;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Markas Mythic Path',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.backpack, size: 28),
            tooltip: 'Buka Ransel',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const InventoryScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.storefront, size: 28),
            tooltip: 'Kunjungi Toko',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ShopScreen()),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.deepPurple.withValues(alpha: 0.2),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.withValues(alpha: 0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (user.currentLevel >= 5) {
                            _showClassSelectionDialog(context, ref);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  '🔒 Capai Level 5 dulu untuk berevolusi!',
                                ),
                                backgroundColor: Colors.orange,
                              ),
                            );
                          }
                        },
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.deepPurple[50],
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.deepPurple,
                              width: 3,
                            ),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Text(
                                _getAvatarIcon(
                                  user.classType,
                                  user.currentLevel,
                                ),
                                style: const TextStyle(fontSize: 35),
                              ),
                              if (user.currentLevel >= 5)
                                const Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Icon(
                                    Icons.touch_app,
                                    size: 16,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () => _showEditNameDialog(
                                context,
                                ref,
                                user.username,
                              ),
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      user.username,
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  const Icon(
                                    Icons.edit,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              'Class: ${user.classType}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.deepPurple[50],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '🌟 Lvl ${user.currentLevel}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.amber[50],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '🪙 ${user.gold}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 12,
                      backgroundColor: Colors.grey[200],
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${user.currentXp} / $xpRequired XP',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              '📜 Papan Misi Harian',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: Consumer(
                builder: (context, ref, child) {
                  final quests = ref.watch(questProvider);

                  if (quests.isEmpty) {
                    return const Center(
                      child: Text(
                        'Papan misi kosong. Saatnya istirahat, Pahlawan!',
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: quests.length,
                    itemBuilder: (context, index) {
                      final quest = quests[index];

                      return Dismissible(
                        key: Key(quest.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          margin: const EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Icon(
                            Icons.delete_sweep,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        onDismissed: (direction) {
                          ref
                              .read(questProvider.notifier)
                              .deleteQuest(quest.id);

                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '🗑️ Misi "${quest.title}" dibuang.',
                              ),
                              backgroundColor: Colors.redAccent,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        child: QuestCardWidget(
                          quest: quest,
                          onComplete: () {
                            ref
                                .read(userProvider.notifier)
                                .gainReward(quest.rewardXp, quest.rewardGold);
                            ref
                                .read(questProvider.notifier)
                                .completeQuest(quest.id);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddQuestDialog(context, ref),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text(
          'Misi Baru',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // --- POP-UP GANTI NAMA ---
  void _showEditNameDialog(
    BuildContext context,
    WidgetRef ref,
    String currentName,
  ) {
    final nameController = TextEditingController(text: currentName);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text('Ubah Nama Pahlawan'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(hintText: 'Masukkan namamu...'),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                final newName = nameController.text.trim();
                if (newName.isNotEmpty) {
                  ref.read(userProvider.notifier).changeUsername(newName);
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  // --- POP-UP TAMBAH MISI (VERSI BARU BEBAS ERROR) ---
  void _showAddQuestDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        int selectedDifficulty = 1; // Default: Sedang

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              title: const Text('✨ Buat Misi Baru'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Nama Misi'),
                    ),
                    TextField(
                      controller: descController,
                      decoration: const InputDecoration(
                        labelText: 'Deskripsi Singkat',
                      ),
                    ),
                    const SizedBox(height: 20),

                    const Text(
                      'Tingkat Kesulitan:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: [
                        ChoiceChip(
                          label: const Text('🟢 Mudah'),
                          selected: selectedDifficulty == 0,
                          onSelected: (bool selected) {
                            setState(() {
                              selectedDifficulty = 0;
                            });
                          },
                        ),
                        ChoiceChip(
                          label: const Text('🟡 Sedang'),
                          selected: selectedDifficulty == 1,
                          onSelected: (bool selected) {
                            setState(() {
                              selectedDifficulty = 1;
                            });
                          },
                        ),
                        ChoiceChip(
                          label: const Text('🔴 Sulit'),
                          selected: selectedDifficulty == 2,
                          onSelected: (bool selected) {
                            setState(() {
                              selectedDifficulty = 2;
                            });
                          },
                        ),
                        ChoiceChip(
                          label: const Text('🟣 Epic'),
                          selected: selectedDifficulty == 3,
                          onSelected: (bool selected) {
                            setState(() {
                              selectedDifficulty = 3;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Batal',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final title = titleController.text.trim();
                    final desc = descController.text.trim();

                    if (title.isNotEmpty) {
                      // Logika Perhitungan Hadiah
                      int finalXp = 0;
                      int finalGold = 0;

                      if (selectedDifficulty == 0) {
                        finalXp = 20;
                        finalGold = 5;
                      } else if (selectedDifficulty == 1) {
                        finalXp = 50;
                        finalGold = 15;
                      } else if (selectedDifficulty == 2) {
                        finalXp = 100;
                        finalGold = 30;
                      } else if (selectedDifficulty == 3) {
                        finalXp = 250;
                        finalGold = 100;
                      }

                      final newId = DateTime.now().millisecondsSinceEpoch
                          .toString();

                      ref
                          .read(questProvider.notifier)
                          .addQuest(
                            QuestModel(
                              id: newId,
                              title: title,
                              description: desc,
                              rewardXp: finalXp,
                              rewardGold: finalGold,
                            ),
                          );
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Simpan Misi'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // --- POP-UP PILIH CLASS ---
  void _showClassSelectionDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text('✨ Evolusi Profesi', textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Pilih jalan ninjamu, Pahlawan!',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              _buildClassOption(
                context,
                ref,
                'Warrior',
                '🛡️',
                'Fokus Fisik & Olahraga',
              ),
              const SizedBox(height: 10),
              _buildClassOption(
                context,
                ref,
                'Mage',
                '🧙‍♂️',
                'Fokus Belajar & Otak',
              ),
              const SizedBox(height: 10),
              _buildClassOption(
                context,
                ref,
                'Rogue',
                '🥷',
                'Fokus Produktivitas',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildClassOption(
    BuildContext context,
    WidgetRef ref,
    String className,
    String icon,
    String desc,
  ) {
    return InkWell(
      onTap: () {
        ref.read(userProvider.notifier).changeClass(className);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('🎉 Berhasil berevolusi menjadi $className!'),
            backgroundColor: Colors.green,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 30)),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    className,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    desc,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
