import 'package:flutter/material.dart';
import '../app/theme.dart';
import '../game/crypto_engine.dart';
import 'puzzle_shared.dart';

// =============================================================================
// SECTION: Puzzle — Mission 0: Caesar Cipher (Shift Slider)
// =============================================================================

class PuzzleCaesar extends StatefulWidget {
  final VoidCallback onSolved;
  const PuzzleCaesar({super.key, required this.onSolved});

  @override
  State<PuzzleCaesar> createState() => _PuzzleCaesarState();
}

class _PuzzleCaesarState extends State<PuzzleCaesar> {
  int  _shift     = 1;
  bool _solved    = false;
  bool _showWrong = false;

  String get _decoded =>
      CryptoEngine.caesarDecrypt(CryptoEngine.mission1Ciphertext, _shift);

  void _confirm() {
    if (_shift == CryptoEngine.mission1CorrectShift) {
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
    const accent = AppColors.orange;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PuzzleCipherBox(label: 'INTERCEPTED MESSAGE', text: CryptoEngine.mission1Ciphertext, color: AppColors.red),
        const SizedBox(height: 20),
        Text('SHIFT KEY: $_shift', style: AppText.mono(11, accent, FontWeight.bold)),
        const SizedBox(height: 4),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: accent,
            inactiveTrackColor: AppColors.bgPanel,
            thumbColor: accent,
            overlayColor: accent.withOpacity(0.15),
          ),
          child: Slider(
            value: _shift.toDouble(),
            min: 1, max: 25, divisions: 24,
            label: '$_shift',
            onChanged: (v) => setState(() => _shift = v.round()),
          ),
        ),
        const SizedBox(height: 12),
        PuzzleCipherBox(
          label: 'DECODED PREVIEW',
          text: _decoded,
          color: _solved ? AppColors.green : accent,
        ),
        const SizedBox(height: 16),
        AlphabetShiftHelper(shift: _shift),
        const SizedBox(height: 20),
        if (_showWrong)
          PuzzleFeedback(message: 'Not quite — adjust the shift until the decoded text makes sense!', color: AppColors.red),
        if (_solved)
          PuzzleFeedback(message: '✅ Correct! Shift = $_shift  →  "$_decoded"', color: AppColors.green),
        if (!_solved)
          PuzzleConfirmButton(label: 'CONFIRM DECODE', accent: accent, onTap: _confirm),
      ],
    );
  }
}
