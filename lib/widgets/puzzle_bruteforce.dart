import 'package:flutter/material.dart';
import '../app/theme.dart';
import '../game/crypto_engine.dart';
import 'puzzle_shared.dart';

// =============================================================================
// SECTION: Puzzle — Mission 1: Brute Force (Select the Correct Decryption)
// =============================================================================

class PuzzleBruteForce extends StatefulWidget {
  final VoidCallback onSolved;
  const PuzzleBruteForce({super.key, required this.onSolved});

  @override
  State<PuzzleBruteForce> createState() => _PuzzleBruteForceState();
}

class _PuzzleBruteForceState extends State<PuzzleBruteForce> {
  int?  _selected;
  bool  _wrong = false;

  void _tap(int shift) {
    setState(() => _selected = shift);
    if (shift == CryptoEngine.mission2CorrectShift) {
      Future.delayed(const Duration(milliseconds: 700), widget.onSolved);
    } else {
      setState(() => _wrong = true);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() { _wrong = false; _selected = null; });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const accent = AppColors.red;
    final shifts = CryptoEngine.allCaesarShifts(CryptoEngine.mission2Ciphertext);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PuzzleCipherBox(label: 'CIPHERTEXT', text: CryptoEngine.mission2Ciphertext, color: accent),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.borderDefault),
          ),
          child: Text(
            'Tap the decoded line that reads like a real English sentence:',
            style: AppText.body(13, AppColors.textSecondary),
          ),
        ),
        const SizedBox(height: 10),
        if (_wrong) ...[
          PuzzleFeedback(message: 'That doesn\'t look like real English. Keep scanning!', color: AppColors.red),
          const SizedBox(height: 6),
        ],
        ...shifts.map((e) => _ShiftRow(
          shift: e.key,
          decoded: e.value,
          selected: _selected == e.key,
          correct: e.key == CryptoEngine.mission2CorrectShift && _selected == e.key,
          onTap: () => _tap(e.key),
        )),
      ],
    );
  }
}

// =============================================================================
// SECTION: Shift Row Widget (one decoded attempt per row)
// =============================================================================

class _ShiftRow extends StatelessWidget {
  final int      shift;
  final String   decoded;
  final bool     selected;
  final bool     correct;
  final VoidCallback onTap;
  const _ShiftRow({required this.shift, required this.decoded, required this.selected, required this.correct, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final border = selected
        ? (correct ? AppColors.green : AppColors.red)
        : AppColors.borderDefault;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 5),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? border.withOpacity(0.08) : AppColors.bgCard,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: border),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 26,
              child: Text('$shift', style: AppText.mono(9, AppColors.textMuted), textAlign: TextAlign.center),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(decoded, style: AppText.mono(12, AppColors.textPrimary), overflow: TextOverflow.ellipsis),
            ),
            if (correct) const Icon(Icons.check_circle_rounded, color: AppColors.green, size: 16),
          ],
        ),
      ),
    );
  }
}
