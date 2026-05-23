import 'package:flutter/material.dart';
import '../app/theme.dart';
import '../game/crypto_engine.dart';

// =============================================================================
// SECTION: Shared Puzzle UI Widgets — Used by All 5 Puzzle Files
// =============================================================================

/// Displays a labeled box with ciphertext or decoded text.
class PuzzleCipherBox extends StatelessWidget {
  final String label;
  final String text;
  final Color  color;
  const PuzzleCipherBox({super.key, required this.label, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgDeep,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppText.mono(8, color.withOpacity(0.8), FontWeight.bold)),
          const SizedBox(height: 6),
          Text(text, style: AppText.mono(16, color, FontWeight.bold)),
        ],
      ),
    );
  }
}

/// Colored left-border feedback / hint box.
class PuzzleFeedback extends StatelessWidget {
  final String message;
  final Color  color;
  const PuzzleFeedback({super.key, required this.message, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border(left: BorderSide(color: color, width: 3)),
      ),
      child: Text(message, style: AppText.body(13, color)),
    );
  }
}

/// Full-width confirm button.
class PuzzleConfirmButton extends StatelessWidget {
  final String   label;
  final Color    accent;
  final VoidCallback onTap;
  const PuzzleConfirmButton({super.key, required this.label, required this.accent, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: accent.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: accent, width: 2),
        ),
        alignment: Alignment.center,
        child: Text(label, style: AppText.mono(13, accent, FontWeight.bold)),
      ),
    );
  }
}

/// Shows a two-row alphabet with the current Caesar shift applied.
class AlphabetShiftHelper extends StatelessWidget {
  final int shift;
  const AlphabetShiftHelper({super.key, required this.shift});

  @override
  Widget build(BuildContext context) {
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final shifted  = letters.split('').map((c) {
      final i = letters.indexOf(c);
      return letters[(i + shift) % 26];
    }).join();

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Column(
        children: [
          Text('PLAIN:', style: AppText.mono(7, AppColors.textMuted)),
          Row(children: letters.split('').map((c) => _Cell(c, AppColors.textMuted)).toList()),
          const SizedBox(height: 2),
          Text('CIPHER (shift $shift):', style: AppText.mono(7, AppColors.orange)),
          Row(children: shifted.split('').map((c) => _Cell(c, AppColors.orange)).toList()),
        ],
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  final String letter;
  final Color  color;
  const _Cell(this.letter, this.color);

  @override
  Widget build(BuildContext context) => Expanded(
        child: Text(letter, style: AppText.mono(8, color, FontWeight.bold), textAlign: TextAlign.center),
      );
}
