import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/shared_prefs_provider.dart';
import 'screens/dashboard_screen.dart';
import 'screens/prologue_screen.dart'; // Import layar cerita baru kita

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  // Cek apakah pemain sudah pernah melihat prologue?
  // Jika datanya tidak ada (null), berarti dia belum pernah melihat (kembalikan false)
  final hasSeenPrologue = prefs.getBool('has_seen_prologue') ?? false;

  runApp(
    ProviderScope(
      overrides: [sharedPrefsProvider.overrideWithValue(prefs)],
      // Kirim statusnya ke dalam aplikasi
      child: MythicPathApp(hasSeenPrologue: hasSeenPrologue),
    ),
  );
}

class MythicPathApp extends StatelessWidget {
  final bool hasSeenPrologue; // Terima status dari main()

  const MythicPathApp({super.key, required this.hasSeenPrologue});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mythic Path',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      // LOGIKA SAKTI: Jika belum lihat prologue, buka PrologueScreen. Jika sudah, buka Dashboard.
      // home: const PrologueScreen(),
      home: hasSeenPrologue ? const DashboardScreen() : const PrologueScreen(),
    );
  }
}
