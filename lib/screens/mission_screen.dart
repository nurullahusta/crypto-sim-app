import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app/theme.dart';
import '../game/game_state.dart';
import '../game/mission_data.dart';
import '../widgets/puzzle_caesar.dart';
import '../widgets/puzzle_bruteforce.dart';
import '../widgets/puzzle_vigenere.dart';
import '../widgets/puzzle_asymmetric.dart';
import '../widgets/puzzle_hash.dart';

// =============================================================================
// SECTION: Mission Screen — Briefing → Puzzle → Reveal State Machine
// =============================================================================

class MissionScreen extends StatelessWidget {
  const MissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<GameState>();
    final mission = MissionCatalog.byId(state.activeMissionId);

    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context, state, mission),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                switchInCurve: Curves.easeOut,
                child: _buildPhaseContent(context, state, mission),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Top Bar ───────────────────────────────────────────────────────────────

  Widget _buildTopBar(BuildContext context, GameState state, Mission mission) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.bgDark,
        border: Border(bottom: BorderSide(color: mission.accentColor.withOpacity(0.3))),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
            color: AppColors.textSecondary,
            onPressed: () {
              state.exitMission();
              Navigator.pop(context);
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32),
          ),
          const SizedBox(width: 8),
          Text(mission.emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(mission.codename, style: AppText.mono(8, mission.accentColor, FontWeight.bold)),
                Text(mission.title, style: AppText.body(13, AppColors.textPrimary)),
              ],
            ),
          ),
          // Phase indicator
          _PhaseIndicator(phase: state.phase, accent: mission.accentColor),
        ],
      ),
    );
  }

  // ── Phase Router ──────────────────────────────────────────────────────────

  Widget _buildPhaseContent(BuildContext context, GameState state, Mission mission) {
    switch (state.phase) {
      case MissionPhase.briefing:
        return _BriefingPhase(key: const ValueKey('briefing'), mission: mission);
      case MissionPhase.puzzle:
        return _PuzzlePhase(key: const ValueKey('puzzle'), mission: mission);
      case MissionPhase.reveal:
        return _RevealPhase(key: const ValueKey('reveal'), mission: mission);
    }
  }
}

// =============================================================================
// SECTION: Phase Indicator Widget
// =============================================================================

class _PhaseIndicator extends StatelessWidget {
  final MissionPhase phase;
  final Color accent;
  const _PhaseIndicator({required this.phase, required this.accent});

  @override
  Widget build(BuildContext context) {
    final labels = ['BRIEF', 'PUZZLE', 'REVEAL'];
    final current = phase.index;
    return Row(
      children: List.generate(3, (i) {
        final active = i == current;
        final done   = i < current;
        return Row(
          children: [
            Container(
              width: active ? 8 : 6,
              height: active ? 8 : 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: done ? accent : active ? accent : AppColors.borderDefault,
              ),
            ),
            if (i < 2)
              Container(
                width: 12, height: 1,
                color: done ? accent.withOpacity(0.4) : AppColors.borderDefault,
              ),
          ],
        );
      }),
    );
  }
}

// =============================================================================
// SECTION: Briefing Phase — Story + Start Puzzle Button
// =============================================================================

class _BriefingPhase extends StatelessWidget {
  final Mission mission;
  const _BriefingPhase({super.key, required this.mission});

  @override
  Widget build(BuildContext context) {
    final accent = mission.accentColor;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Classification banner
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
            decoration: BoxDecoration(
              color: accent.withOpacity(0.08),
              border: Border.all(color: accent.withOpacity(0.4)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_outlined, color: accent, size: 13),
                const SizedBox(width: 6),
                Text(
                  'CLASSIFIED — EYES ONLY',
                  style: AppText.mono(9, accent, FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Mission briefing text
          Text(
            mission.briefing,
            style: AppText.body(14, AppColors.textSecondary),
          ),
          const SizedBox(height: 28),

          // Reward preview
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderDefault),
            ),
            child: Row(
              children: [
                const Text('🏅', style: TextStyle(fontSize: 24)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Mission Reward', style: AppText.mono(9, AppColors.textMuted)),
                      Text('+${mission.xpReward} XP  •  ${mission.badge}',
                          style: AppText.body(13, AppColors.textPrimary)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Start puzzle button
          GestureDetector(
            onTap: () => context.read<GameState>().advanceToPuzzle(),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [accent.withOpacity(0.25), accent.withOpacity(0.08)],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: accent, width: 2),
                boxShadow: [BoxShadow(color: accent.withOpacity(0.2), blurRadius: 16)],
              ),
              alignment: Alignment.center,
              child: Text(
                '⚡  START MISSION',
                style: AppText.mono(14, accent, FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// SECTION: Puzzle Phase — Routes to the Correct Puzzle Widget
// =============================================================================

class _PuzzlePhase extends StatelessWidget {
  final Mission mission;
  const _PuzzlePhase({super.key, required this.mission});

  @override
  Widget build(BuildContext context) {
    void onSolved() {
      context.read<GameState>().advanceToReveal(mission.id, mission.xpReward);
    }

    Widget puzzle;
    switch (mission.puzzleType) {
      case PuzzleType.caesar:
        puzzle = PuzzleCaesar(onSolved: onSolved);
        break;
      case PuzzleType.bruteForce:
        puzzle = PuzzleBruteForce(onSolved: onSolved);
        break;
      case PuzzleType.vigenere:
        puzzle = PuzzleVigenere(onSolved: onSolved);
        break;
      case PuzzleType.asymmetric:
        puzzle = PuzzleAsymmetric(onSolved: onSolved);
        break;
      case PuzzleType.hashing:
        puzzle = PuzzleHash(onSolved: onSolved);
        break;
    }

    return Column(
      children: [
        // Puzzle header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          color: AppColors.bgDark,
          child: Text(
            '🔍  SOLVE THE PUZZLE',
            style: AppText.mono(10, mission.accentColor, FontWeight.bold),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: puzzle,
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// SECTION: Reveal Phase — Educational Debrief + XP Celebration
// =============================================================================

class _RevealPhase extends StatelessWidget {
  final Mission mission;
  const _RevealPhase({super.key, required this.mission});

  @override
  Widget build(BuildContext context) {
    final accent = mission.accentColor;
    final state  = context.read<GameState>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // XP celebration banner
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [accent.withOpacity(0.2), accent.withOpacity(0.05)],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: accent.withOpacity(0.6), width: 2),
            ),
            child: Column(
              children: [
                Text('MISSION COMPLETE', style: AppText.mono(11, accent, FontWeight.bold)),
                const SizedBox(height: 8),
                Text(mission.badge, style: const TextStyle(fontSize: 32)),
                const SizedBox(height: 8),
                Text(
                  '+${mission.xpReward} XP',
                  style: AppText.heading(26, accent),
                ),
                Text(
                  'You are now: ${state.agentRank}  ${state.rankIcon}',
                  style: AppText.body(13, AppColors.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Educational debrief
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: BorderRadius.circular(12),
              border: Border(left: BorderSide(color: accent, width: 3)),
            ),
            child: Text(
              mission.revelation,
              style: AppText.body(14, AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: 24),

          // Next / Map buttons
          if (!state.isGameComplete) ...[
            GestureDetector(
              onTap: () {
                state.exitMission();
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: accent.withOpacity(0.6)),
                ),
                alignment: Alignment.center,
                child: Text('→  NEXT MISSION', style: AppText.mono(14, accent, FontWeight.bold)),
              ),
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.gold.withOpacity(0.2), AppColors.gold.withOpacity(0.05)],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.gold.withOpacity(0.6)),
              ),
              child: Column(
                children: [
                  const Text('🏆', style: TextStyle(fontSize: 48)),
                  const SizedBox(height: 8),
                  Text('ALL MISSIONS COMPLETE!', style: AppText.mono(13, AppColors.gold, FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text('Total XP: ${state.xp}', style: AppText.heading(20, AppColors.gold)),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      state.exitMission();
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      decoration: BoxDecoration(
                        color: AppColors.gold.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.gold.withOpacity(0.5)),
                      ),
                      child: Text('Return to HQ', style: AppText.mono(13, AppColors.gold, FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
