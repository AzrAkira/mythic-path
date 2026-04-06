import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 1. Import Riverpod
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard_screen.dart';
import '../providers/user_provider.dart'; // 2. Import User Provider

// 3. Ubah menjadi ConsumerStatefulWidget agar bisa membaca data User
class PrologueScreen extends ConsumerStatefulWidget {
  const PrologueScreen({super.key});

  @override
  ConsumerState<PrologueScreen> createState() => _PrologueScreenState();
}

class _PrologueScreenState extends ConsumerState<PrologueScreen> {
  int _currentDialogIndex = 0;

  // --- 📖 SCRIPT VISUAL NOVEL (SEKARANG DINAMIS!) ---
  // Kita ubah list ini menjadi sebuah fungsi yang menerima 'playerName'
  List<Map<String, dynamic>> _getDialogues(String playerName) {
    return [
      {
        "speaker": "Zaman Sangkala",
        "text":
            "Selama beberapa generasi, kepulauan Nusantara—bertatahkan permata dari kemegahan tropis dan sihir kuno—telah makmur di bawah pengawasan para Dewa dan perlindungan roh leluhur, para Hyang.",
        "bgImage": "assets/images/Prologue1.png", // Pemandangan candi/tropis
        // "character": "🌴",
      },
      {
        "speaker": "Zaman Sangkala",
        "text":
            "Dari jantung Jawa yang berapi-api hingga hutan hujan Kalimantan yang berbisik, kehidupan adalah simfoni selaras dengan alam. Dunia berdesir dengan Kesaktian yang sakral.",
        "bgImage": "assets/images/Prologue2.png",
        // "character": "🌋",
      },
      {
        "speaker": "Zaman Sangkala",
        "text":
            "Namun, bayangan jatuh di tanah yang diberkati ini. Dari alam jurang Kedewan, muncul Raja Iblis Waktu dan Kehancuran... Raja Iblis Kala.",
        "bgImage": "assets/images/Prologue3.png", // Hutan gelap/mistis
        // "character": "🌑",
      },
      {
        "speaker": "Zaman Sangkala",
        "text":
            "Kehadirannya memutarbalikkan realitas, mengubah roh baik menjadi Leak jahat dan menguras kesaktian situs suci. Ramalan Sangkala—zaman kegelapan—telah tiba di Nusantara.",
        "bgImage": "assets/images/Prologue4.png",
        // "character": "👹",
      },
      {
        "speaker": "Para Hyang",
        "text":
            "Kekuatan kasar tidaklah cukup. Kunci untuk mengalahkan Raja Iblis Kala terletak di masa kini—di dalam keturunan Nusantara. Kami telah menanamkan sihir kuno ke dalam era digital...",
        "bgImage": "assets/images/Prologue5.png", // Cahaya kebangkitan
        // "character": "✨",
      },
      {
        "speaker": "Sistem Mythic Path",
        "text":
            "Ini bukan sekadar permainan; ini adalah kontrak spiritual. Anda adalah Satria Piningit modern. Tindakan ketekunan dan disiplin di kehidupan nyata akan menyalurkan Prana ke dalam avatar digital Anda.",
        "bgImage": "assets/images/Prologue6.png", // Estetika digital/koin
        // "character": "📱",
      },
      {
        "speaker": "Sistem Mythic Path",
        "text":
            "Setiap langkah yang Anda ambil memberdayakan pahlawan Anda. Keringat Anda menjadi kekuatan mereka, fokus Anda menjadi sihir mereka.",
        "bgImage": "assets/images/Prologue7.png",
        // "character": "💧",
      },
      {
        "speaker": "Sistem Mythic Path",
        "text":
            "Selamat datang di Mythic Path. Latih semangat Anda, asah disiplin Anda, dan tempa Pusaka legendaris.",
        "bgImage": "assets/images/Prologue8.png", // Layar gelap neon/elegan
        // "character": "🗡️",
      },
      {
        "speaker": "Sistem Mythic Path",
        "text":
            "Nusantara memanggil anak-anaknya. Maukah Anda menjawab panggilan tersebut, $playerName? Nasib kepulauan ini bergantung pada kerja keras harian Anda.",
        "bgImage": "assets/images/Prologue9.png",
        // "character": "🥷",
      },
    ];
  }

  void _nextDialog(int totalDialogs) {
    setState(() {
      if (_currentDialogIndex < totalDialogs - 1) {
        _currentDialogIndex++;
      } else {
        _completePrologue();
      }
    });
  }

  void _completePrologue() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_prologue', true);

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const DashboardScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 4. Ambil nama asli karakter dari Provider!
    final playerName = ref.watch(userProvider).username;

    // 5. Muat naskah cerita yang sudah disisipi nama karakter
    final dialogues = _getDialogues(playerName);
    final currentLine = dialogues[_currentDialogIndex];

    return Scaffold(
      body: GestureDetector(
        onTap: () => _nextDialog(dialogues.length),
        child: Stack(
          children: [
            // LAYER 1: BACKGROUND GAMBAR
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 1000),
              child: Container(
                key: ValueKey(currentLine["bgImage"]),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(currentLine["bgImage"]),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.5),
                      BlendMode.darken,
                    ),
                  ),
                ),
              ),
            ),

            // LAYER 2: KARAKTER (Di tengah layar)
            Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                // child: Text(
                //   currentLine["character"],
                //   key: ValueKey(currentLine["character"]),
                //   style: const TextStyle(fontSize: 120),
                // ),
              ),
            ),

            // LAYER 3: KOTAK DIALOG
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.white38, width: 1),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentLine["speaker"],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        // Warna nama berubah: Biru kalau pemain yang bicara, Emas kalau karakter lain
                        color: currentLine["speaker"] == playerName
                            ? Colors.blueAccent
                            : Colors.amber,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      currentLine["text"],
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Tap untuk lanjut ▼",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
