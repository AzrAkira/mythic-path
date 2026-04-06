import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/inventory_provider.dart';

class InventoryScreen extends ConsumerWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Pantau terus isi tasmu
    final inventory = ref.watch(inventoryProvider);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Ransel Pusaka',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor:
            Colors.brown[600], // Warna kulit/kayu untuk tas petualang
        foregroundColor: Colors.white,
      ),
      body: inventory.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('🎒', style: TextStyle(fontSize: 80)),
                  const SizedBox(height: 20),
                  Text(
                    'Ranselmu masih kosong.\nSelesaikan misi dan beli item di Toko!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemCount: inventory.length,
                itemBuilder: (context, index) {
                  final item = inventory[index];

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
                          // Stack untuk menaruh Angka Jumlah (Quantity) di pojok ikon
                          Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  item.icon,
                                  style: const TextStyle(fontSize: 50),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Colors.redAccent,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  'x${item.quantity}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            item.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.brown[500],
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                // Pakai barangnya!
                                ref
                                    .read(inventoryProvider.notifier)
                                    .useItem(item.id);

                                ScaffoldMessenger.of(context).clearSnackBars();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '✨ Kamu menggunakan ${item.title}!',
                                    ),
                                    backgroundColor: Colors.blueAccent,
                                  ),
                                );
                              },
                              child: const Text('Gunakan'),
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
