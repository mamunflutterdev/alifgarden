import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';

class ArabicAlphabetHome extends StatefulWidget {
  const ArabicAlphabetHome({super.key});

  @override
  State<ArabicAlphabetHome> createState() => _ArabicAlphabetHomeState();
}

class _ArabicAlphabetHomeState extends State<ArabicAlphabetHome> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  final List<Map<String, dynamic>> arabicAlphabets = [
    {'letter': 'ا', 'name': 'আলিফ', 'audio': 'assets/audio/alif.wav'},
    {'letter': 'ب', 'name': 'বা', 'audio': 'assets/audio/ba.wav'},
    {'letter': 'ت', 'name': 'তা', 'audio': 'assets/audio/ta.wav'},
    {'letter': 'ث', 'name': 'ছা', 'audio': 'assets/audio/sa.wav'},
    {'letter': 'ج', 'name': 'জীম', 'audio': 'assets/audio/jeem.wav'},
    {'letter': 'ح', 'name': 'হা', 'audio': 'assets/audio/ha.wav'},
    {'letter': 'خ', 'name': 'খ', 'audio': 'assets/audio/kha.wav'},
    {'letter': 'د', 'name': 'দাল', 'audio': 'assets/audio/dal.wav'},
    {'letter': 'ذ', 'name': 'যাল', 'audio': 'assets/audio/jal.wav'},
    {'letter': 'ر', 'name': 'রা', 'audio': 'assets/audio/ra.wav'},
    {'letter': 'ز', 'name': 'যা', 'audio': 'assets/audio/za.wav'},
    {'letter': 'س', 'name': 'সীন', 'audio': 'assets/audio/seen.wav'},
    {'letter': 'ش', 'name': 'শীন', 'audio': 'assets/audio/sheen.wav'},
    {'letter': 'ص', 'name': 'সোয়াদ', 'audio': 'assets/audio/swad.wav'},
    {'letter': 'ض', 'name': 'দোয়াদ', 'audio': 'assets/audio/dwad.wav'},
    {'letter': 'ط', 'name': 'তো', 'audio': 'assets/audio/to.wav'},
    {'letter': 'ظ', 'name': 'যো', 'audio': 'assets/audio/tho.wav'},
    {'letter': 'ع', 'name': 'আইন', 'audio': 'assets/audio/ain.wav'},
    {'letter': 'غ', 'name': 'গইন', 'audio': 'assets/audio/ghain.wav'},
    {'letter': 'ف', 'name': 'ফা', 'audio': 'assets/audio/fa.wav'},
    {'letter': 'ق', 'name': 'ক্বফ', 'audio': 'assets/audio/qaf.wav'},
    {'letter': 'ك', 'name': 'কাফ', 'audio': 'assets/audio/kaf.wav'},
    {'letter': 'ل', 'name': 'লাম', 'audio': 'assets/audio/lam.wav'},
    {'letter': 'م', 'name': 'মীম', 'audio': 'assets/audio/meem.wav'},
    {'letter': 'ن', 'name': 'নূন', 'audio': 'assets/audio/noon.wav'},
    {'letter': 'و', 'name': 'ওয়াও', 'audio': 'assets/audio/waw.wav'},
    {'letter': 'ه', 'name': 'হা', 'audio': 'assets/audio/hha.wav'},
    {'letter': 'ء', 'name': 'হামজা', 'audio': 'assets/audio/hamza.wav'},
    {'letter': 'ي', 'name': 'ইয়া', 'audio': 'assets/audio/ya.wav'}
  ];

  int selectedIndex = 0;
  final ScrollController _scrollController = ScrollController();
  bool isAutoPlaying = true; // Add this variable to control auto-play

  @override
  void initState() {
    super.initState();
    
    // Add initial delay before starting the auto-selection
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        // Play first letter audio
        playLetterAudio(selectedIndex);
        // Start the auto-selection timer
        startAutoSelection();
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> playLetterAudio(int index) async {
    try {
      await _audioPlayer.setAsset(arabicAlphabets[index]['audio']);
      await _audioPlayer.play();
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  void startAutoSelection() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          selectedIndex = (selectedIndex + 1) % arabicAlphabets.length;
        });

        // সব সময় অডিও প্লে করবে, isAutoPlaying চেক করার দরকার নেই
        playLetterAudio(selectedIndex);

        // Calculate the position to scroll to
        final itemHeight = MediaQuery.of(context).size.width > 600 
            ? (MediaQuery.of(context).size.width - 32) / 6 
            : (MediaQuery.of(context).size.width - 32) / 2;
            
        final rowIndex = selectedIndex ~/ (MediaQuery.of(context).size.width > 600 ? 6 : 2);
        final scrollPosition = rowIndex * itemHeight;

        // Smooth scroll to the selected item
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            scrollPosition,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }

        startAutoSelection(); // Continue the cycle
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'আলিফ গার্ডেন',
          style: GoogleFonts.hindSiliguri(
            color: Colors.white,
            fontSize: isWeb ? 30 : 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        toolbarHeight: isWeb ? 90 : 56, // Taller AppBar for web
        elevation: isWeb ? 8 : 4,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = constraints.maxWidth > 600 ? 6 : 2;
          
          return GridView.builder(
            controller: _scrollController, // Add scroll controller
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: 1.0,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: arabicAlphabets.length,
            itemBuilder: (context, index) {
              final isSelected = selectedIndex == index;
              
              return Card(
                elevation: 4,
                color: isSelected ? Colors.green.shade700 : null,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                      // Always play audio on tap, regardless of auto-play setting
                      playLetterAudio(index);
                    });
                  },
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          arabicAlphabets[index]['letter']!,
                          style: GoogleFonts.amiri(
                            fontSize: constraints.maxWidth > 600 ? 60 : 50,
                            fontWeight: FontWeight.bold,
                            color: isSelected 
                                ? Colors.white 
                                : Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          arabicAlphabets[index]['name']!,
                          style: GoogleFonts.notoSerifBengali(
                            fontSize: constraints.maxWidth > 600 ? 30 : 20,
                            color: isSelected ? Colors.white : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
