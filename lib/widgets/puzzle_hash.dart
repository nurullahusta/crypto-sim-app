import 'package:flutter/material.dart';
import '../app/theme.dart';
import '../game/crypto_engine.dart';
import 'puzzle_shared.dart';

// =============================================================================
// SECTION: Puzzle — Mission 4: Hash Function (Tamper Detection)
// =============================================================================

class PuzzleHash extends StatefulWidget {
  final VoidCallback onSolved;
  const PuzzleHash({super.key, required this.onSolved});

  @override
  State<PuzzleHash> createState() => _PuzzleHashState();
}

class _PuzzleHashState extends State<PuzzleHash> {
  static const _originalMsg = CryptoEngine.mission5Original;
  static const _tamperedMsg = CryptoEngine.mission5Tampered;

  bool? _verdict;
  bool  _showWrong = false;
  bool  _phase2    = false;

  String get _originalHash => CryptoEngine.hash(_originalMsg);
  String get _receivedHash => CryptoEngine.hash(_tamperedMsg);

  void _judge(bool isTampered) {
    if (isTampered) {
      setState(() { _verdict = true; });
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) setState(() => _phase2 = true);
      });
    } else {
      setState(() { _verdict = false; _showWrong = true; });
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() { _verdict = null; _showWrong = false; });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _DocCard(
          label: 'HQ\'S ORIGINAL DOCUMENT',
          text: _originalMsg,
          hash: _originalHash,
          color: AppColors.green,
        ),
        const SizedBox(height: 12),
        _DocCard(
          label: 'DOCUMENT YOU RECEIVED',
          text: _tamperedMsg,
          hash: _receivedHash,
          color: AppColors.red,
        ),
        const SizedBox(height: 16),

        if (!_phase2) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.borderDefault),
            ),
            child: Text(
              'Compare the two hashes. Are they identical?\nWas the received document tampered with?',
              style: AppText.body(13, AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: 14),
          if (_showWrong)
            _Feedback(message: 'Look at the hashes again — are they exactly the same?', color: AppColors.red),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _judge(true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.redDim,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.red.withOpacity(0.6)),
                    ),
                    alignment: Alignment.center,
                    child: Text('⚠️  TAMPERED', style: AppText.mono(12, AppColors.red, FontWeight.bold)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () => _judge(false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.greenDim,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.green.withOpacity(0.6)),
                    ),
                    alignment: Alignment.center,
                    child: Text('✅  SAFE', style: AppText.mono(12, AppColors.green, FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        ],

        if (_phase2) ...[
          _Feedback(message: '✅ Correct! The document was tampered — the hashes don\'t match!', color: AppColors.green),
          const SizedBox(height: 16),
          _AvalancheDemo(onDone: widget.onSolved),
        ],
      ],
    );
  }
}

// =============================================================================
// SECTION: Document Card Helper
// =============================================================================

class _DocCard extends StatelessWidget {
  final String label;
  final String text;
  final String hash;
  final Color  color;
  const _DocCard({required this.label, required this.text, required this.hash, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppText.mono(8, color.withOpacity(0.8), FontWeight.bold)),
          const SizedBox(height: 6),
          Text(text, style: AppText.body(13, AppColors.textPrimary)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.bgDeep,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('HASH:', style: AppText.mono(7, AppColors.textMuted)),
                const SizedBox(height: 2),
                Text(hash, style: AppText.mono(9, color, FontWeight.bold), overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// SECTION: Avalanche Effect Live Demo
// =============================================================================

class _AvalancheDemo extends StatefulWidget {
  final VoidCallback onDone;
  const _AvalancheDemo({required this.onDone});

  @override
  State<_AvalancheDemo> createState() => _AvalancheDemoState();
}

class _AvalancheDemoState extends State<_AvalancheDemo> {
  final _ctrl = TextEditingController(text: 'hello');
  bool  _done = false;

  @override
  void initState() {
    super.initState();
    _ctrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hash = _ctrl.text.isEmpty ? '' : CryptoEngine.hash(_ctrl.text);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.goldDim.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.gold.withOpacity(0.4)),
          ),
          child: Text(
            '⚡ BONUS: See the Avalanche Effect!\nChange any character and watch the hash completely transform:',
            style: AppText.body(12, AppColors.textSecondary),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _ctrl,
          style: AppText.mono(14, AppColors.textPrimary),
          cursorColor: AppColors.gold,
          decoration: InputDecoration(
            hintText: 'Type anything…',
            hintStyle: AppText.mono(11, AppColors.textMuted),
          ),
        ),
        const SizedBox(height: 10),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 120),
          child: Container(
            key: ValueKey(hash),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.bgDeep,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.gold.withOpacity(0.4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('HASH OUTPUT:', style: AppText.mono(8, AppColors.textMuted)),
                const SizedBox(height: 4),
                Text(hash.isEmpty ? '—' : hash,
                    style: AppText.mono(11, AppColors.gold, FontWeight.bold)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        if (!_done)
          GestureDetector(
            onTap: () { setState(() => _done = true); widget.onDone(); },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.gold.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.gold.withOpacity(0.6)),
              ),
              alignment: Alignment.center,
              child: Text('🏆  COMPLETE MISSION', style: AppText.mono(13, AppColors.gold, FontWeight.bold)),
            ),
          ),
      ],
    );
  }
}
