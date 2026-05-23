import 'package:flutter/material.dart';
import '../app/theme.dart';
import '../game/crypto_engine.dart';
import 'puzzle_shared.dart';

// =============================================================================
// SECTION: Puzzle — Mission 2: Vigenère / Symmetric Key
// =============================================================================

class PuzzleVigenere extends StatefulWidget {
  final VoidCallback onSolved;
  const PuzzleVigenere({super.key, required this.onSolved});

  @override
  State<PuzzleVigenere> createState() => _PuzzleVigenereState();
}

class _PuzzleVigenereState extends State<PuzzleVigenere> {
  final _keyCtrl   = TextEditingController();
  bool  _solved    = false;
  bool  _showWrong = false;

  String get _decoded =>
      CryptoEngine.vigenereDecrypt(CryptoEngine.mission3Cipher, _keyCtrl.text.trim().toUpperCase());

  bool get _isCorrect =>
      _keyCtrl.text.trim().toUpperCase() == CryptoEngine.mission3Key;

  @override
  void initState() {
    super.initState();
    _keyCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _keyCtrl.dispose();
    super.dispose();
  }

  void _confirm() {
    if (_isCorrect) {
      setState(() => _solved = true);
      Future.delayed(const Duration(milliseconds: 800), widget.onSolved);
    } else {
      setState(() => _showWrong = true);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => _showWrong = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const accent = AppColors.green;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PuzzleCipherBox(label: 'ENCRYPTED MESSAGE', text: CryptoEngine.mission3Cipher, color: AppColors.red),
        const SizedBox(height: 14),

        // Key hint card
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.gold.withOpacity(0.4)),
          ),
          child: Row(
            children: [
              const Text('🔑', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Our double agent provided the key:', style: AppText.mono(9, AppColors.textMuted)),
                  Text('MOON', style: AppText.mono(16, AppColors.gold, FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        Text('ENTER THE KEY:', style: AppText.mono(10, accent, FontWeight.bold)),
        const SizedBox(height: 6),
        TextField(
          controller: _keyCtrl,
          style: AppText.mono(15, AppColors.textPrimary),
          textCapitalization: TextCapitalization.characters,
          cursorColor: accent,
          enabled: !_solved,
          decoration: InputDecoration(
            hintText: 'Type the keyword…',
            hintStyle: AppText.mono(12, AppColors.textMuted),
            prefixIcon: const Icon(Icons.key_rounded, color: AppColors.green, size: 18),
          ),
        ),
        const SizedBox(height: 14),

        if (_keyCtrl.text.isNotEmpty) ...[
          PuzzleCipherBox(
            label: 'DECODED PREVIEW',
            text: _decoded.isEmpty ? '…' : _decoded,
            color: _solved ? AppColors.green : accent,
          ),
          const SizedBox(height: 14),
        ],

        if (_showWrong)
          PuzzleFeedback(
            message: 'Wrong key — the message is still scrambled. Hint: think of something in the night sky!',
            color: AppColors.red,
          ),
        if (_solved)
          PuzzleFeedback(message: '✅ Decrypted! The message reads: "$_decoded"', color: AppColors.green),

        if (!_solved)
          PuzzleConfirmButton(label: 'CONFIRM DECRYPT', accent: accent, onTap: _confirm),
      ],
    );
  }
}
