import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_provider.dart';
import '../models/reward_model.dart';
import '../providers/inventory_provider.dart'; // Import Ranselmu!

class ShopScreen extends ConsumerWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    final List<RewardModel> shopItems = [
      RewardModel(
        id: 'r1',
        title: 'Kopi Susu',
        description: 'Beli es kopi susu favoritmu.',
        cost: 50,
        icon: '☕',
      ),
      RewardModel(
        id: 'r2',
        title: 'Gaming Time',
        description: 'Main game PC/HP selama 1 jam tanpa rasa bersalah.',
        cost: 300,
        icon: '🎮',
      ),
      RewardModel(
        id: 'r3',
        title: 'Tidur Siang',
        description: 'Tidur siang nyenyak selama 45 menit.',
        cost: 200,
        icon: '🛌',
      ),
      RewardModel(
        id: 'r4',
        title: 'Nonton Film',
        description: 'Bebas nonton 1 episode series Netflix.',
        cost: 400,
        icon: '🍿',
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Toko Mythic',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.amber[700],
        foregroundColor: Colors.white,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Text(
                '🪙 ${user.gold}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio:
                0.70, // Disesuaikan sedikit agar tombol tidak terpotong
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
          ),
          itemCount: shopItems.length,
          itemBuilder: (context, index) {
            final item = shopItems[index];
            final canAfford = user.gold >= item.cost;

            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(item.icon, style: const TextStyle(fontSize: 50)),
                    const SizedBox(height: 10),
                    Text(
                      item.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      item.description,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: canAfford
                              ? Colors.amber[600]
                              : Colors.grey[300],
                          foregroundColor: canAfford
                              ? Colors.white
                              : Colors.grey[600],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          // 1. Coba potong Gold-nya dulu
                          final success = ref
                              .read(userProvider.notifier)
                              .spendGold(item.cost);

                          ScaffoldMessenger.of(context).clearSnackBars();
                          if (success) {
                            // 2. JIKA BERHASIL BELI, MASUKKAN BARANG KE TAS! 🎒
                            ref
                                .read(inventoryProvider.notifier)
                                .addItem(
                                  item.id,
                                  item.title,
                                  item.description,
                                  item.icon,
                                );

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '🎉 Berhasil membeli ${item.title}! Cek Ranselmu.',
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('❌ Gold tidak cukup, Pahlawan!'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        child: Text('🪙 ${item.cost}'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
