import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/inventory_model.dart';
import 'shared_prefs_provider.dart';

class InventoryNotifier extends Notifier<List<InventoryModel>> {
  @override
  List<InventoryModel> build() {
    final prefs = ref.watch(sharedPrefsProvider);
    final inventoryJson = prefs.getStringList('inventory_data');

    // Muat isi tas dari Memory Card saat aplikasi dibuka
    if (inventoryJson != null) {
      return inventoryJson
          .map((jsonStr) => InventoryModel.fromMap(jsonDecode(jsonStr)))
          .toList();
    }
    return []; // Tas kosong jika belum punya apa-apa
  }

  // 📥 Fungsi untuk MEMASUKKAN barang ke tas (Dipanggil saat beli di Toko)
  void addItem(String id, String title, String desc, String icon) {
    // Cek apakah barang ini sudah ada di dalam tas?
    final existingIndex = state.indexWhere((item) => item.id == id);

    if (existingIndex >= 0) {
      // Jika sudah ada, tambahkan saja jumlahnya (Quantity + 1)
      final updatedInventory = [...state];
      updatedInventory[existingIndex] = updatedInventory[existingIndex]
          .copyWith(quantity: updatedInventory[existingIndex].quantity + 1);
      state = updatedInventory;
    } else {
      // Jika belum ada, masukkan sebagai barang baru dengan quantity 1
      state = [
        ...state,
        InventoryModel(
          id: id,
          title: title,
          description: desc,
          icon: icon,
          quantity: 1,
        ),
      ];
    }
    _saveToMemory();
  }

  // 📤 Fungsi untuk MEMAKAI barang dari tas (Dipanggil di layar Inventory)
  void useItem(String id) {
    final existingIndex = state.indexWhere((item) => item.id == id);

    if (existingIndex >= 0) {
      final item = state[existingIndex];

      if (item.quantity > 1) {
        // Jika jumlahnya lebih dari 1, kurangi 1 saja
        final updatedInventory = [...state];
        updatedInventory[existingIndex] = item.copyWith(
          quantity: item.quantity - 1,
        );
        state = updatedInventory;
      } else {
        // Jika jumlahnya tinggal 1 dan dipakai, hapus barang itu dari tas
        state = state.where((item) => item.id != id).toList();
      }
      _saveToMemory();
    }
  }

  // --- FUNGSI RAHASIA UNTUK AUTO SAVE ---
  void _saveToMemory() {
    final prefs = ref.read(sharedPrefsProvider);
    final inventoryJson = state
        .map((item) => jsonEncode(item.toMap()))
        .toList();
    prefs.setStringList('inventory_data', inventoryJson);
  }
}

// Provider yang akan dipanggil oleh UI
final inventoryProvider =
    NotifierProvider<InventoryNotifier, List<InventoryModel>>(
      InventoryNotifier.new,
    );
