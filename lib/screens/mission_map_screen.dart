import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app/theme.dart';
import '../game/game_state.dart';
import '../game/mission_data.dart';

// =============================================================================
// SECTION: Mission Map Screen — Overview of All 5 Missions
// =============================================================================

class MissionMapScreen extends StatelessWidget {
  const MissionMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<GameState>();

    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(state),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                children: [
                  _XpBar(state: state),
                  const SizedBox(height: 24),
                  _sectionLabel('ACTIVE MISSIONS'),
                  const SizedBox(height: 12),
                  ...MissionCatalog.all.asMap().entries.map((e) => _MissionNode(
                    mission: e.value,
                    isCompleted: state.isMissionCompleted(e.key),
                    isUnlocked: state.isMissionUnlocked(e.key),
                    isLast: e.key == MissionCatalog.all.length - 1,
                  )),
                  if (state.isGameComplete) ...[
                    const SizedBox(height: 24),
                    _buildGameCompleteCard(state),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────

  Widget _buildHeader(GameState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: const BoxDecoration(
        color: AppColors.bgDark,
        border: Border(bottom: BorderSide(color: AppColors.borderDefault)),
      ),
      child: Row(
        children: [
          const Text('🕵️', style: TextStyle(fontSize: 22)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('CRYPTOHQ', style: AppText.mono(9, AppColors.cyan, FontWeight.bold)),
                Text('Agent ${state.agentName}', style: AppText.heading(16, AppColors.textPrimary)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.cyanDim,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.cyan.withOpacity(0.4)),
            ),
            child: Row(
              children: [
                Text(state.rankIcon, style: const TextStyle(fontSize: 12)),
                const SizedBox(width: 4),
                Text(state.agentRank, style: AppText.mono(9, AppColors.cyan, FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Row(
      children: [
        Container(width: 3, height: 12, color: AppColors.cyan),
        const SizedBox(width: 8),
        Text(text, style: AppText.mono(10, AppColors.cyan, FontWeight.bold)),
      ],
    );
  }

  Widget _buildGameCompleteCard(GameState state) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.gold.withOpacity(0.15), AppColors.cyan.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gold.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          const Text('🏆', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 10),
          Text('All Missions Complete!', style: AppText.heading(18, AppColors.gold)),
          const SizedBox(height: 6),
          Text(
            'You are now a ${state.agentRank}.\nTotal XP: ${state.xp}',
            style: AppText.body(13, AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// SECTION: XP Progress Bar Widget
// =============================================================================

class _XpBar extends StatelessWidget {
  final GameState state;
  const _XpBar({required this.state});

  @override
  Widget build(BuildContext context) {
    const maxXp = 1000;
    final progress = (state.xp / maxXp).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Experience Points', style: AppText.body(12, AppColors.textSecondary)),
            Text('${state.xp} / $maxXp XP', style: AppText.mono(12, AppColors.cyan, FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.bgPanel,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.cyan),
            minHeight: 10,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${state.completedCount} / ${state.totalMissions} missions complete  •  ${state.agentRank}',
          style: AppText.mono(9, AppColors.textMuted),
        ),
      ],
    );
  }
}

// =============================================================================
// SECTION: Mission Node Widget
// =============================================================================

class _MissionNode extends StatelessWidget {
  final Mission mission;
  final bool    isCompleted;
  final bool    isUnlocked;
  final bool    isLast;

  const _MissionNode({
    required this.mission,
    required this.isCompleted,
    required this.isUnlocked,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final accent = isUnlocked ? mission.accentColor : AppColors.textMuted;

    return Column(
      children: [
        if (mission.id > 0)
          Container(
            width: 2, height: 18,
            margin: const EdgeInsets.only(left: 30),
            color: isUnlocked ? accent.withOpacity(0.4) : AppColors.borderDefault,
          ),
        GestureDetector(
          onTap: isUnlocked
              ? () {
                  context.read<GameState>().startMission(mission.id);
                  Navigator.pushNamed(context, '/mission');
                }
              : null,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isCompleted
                  ? accent.withOpacity(0.08)
                  : isUnlocked
                      ? AppColors.bgCard
                      : AppColors.bgDark,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isCompleted
                    ? accent.withOpacity(0.6)
                    : isUnlocked
                        ? accent.withOpacity(0.3)
                        : AppColors.borderDefault,
                width: isCompleted ? 1.5 : 1,
              ),
              boxShadow: isCompleted
                  ? [BoxShadow(color: accent.withOpacity(0.15), blurRadius: 12)]
                  : null,
            ),
            child: Row(
              children: [
                // Circle indicator
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted ? accent.withOpacity(0.2) : AppColors.bgPanel,
                    border: Border.all(
                      color: isCompleted ? accent : isUnlocked ? accent.withOpacity(0.4) : AppColors.borderDefault,
                      width: isCompleted ? 2 : 1,
                    ),
                  ),
                  child: Center(
                    child: isCompleted
                        ? Icon(Icons.check_rounded, color: accent, size: 22)
                        : Text(mission.emoji, style: const TextStyle(fontSize: 20)),
                  ),
                ),
                const SizedBox(width: 14),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(mission.codename, style: AppText.mono(8, accent.withOpacity(0.8), FontWeight.bold)),
                      const SizedBox(height: 2),
                      Text(mission.title,
                          style: AppText.heading(15, isUnlocked ? AppColors.textPrimary : AppColors.textMuted)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          ...List.generate(5, (i) => Icon(Icons.star_rounded, size: 11,
                              color: i < mission.difficulty ? AppColors.gold : AppColors.borderDefault)),
                          const SizedBox(width: 8),
                          if (isCompleted)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: accent.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text('+${mission.xpReward} XP', style: AppText.mono(8, accent, FontWeight.bold)),
                            )
                          else if (!isUnlocked)
                            Row(children: [
                              const Icon(Icons.lock_outline_rounded, size: 11, color: AppColors.textMuted),
                              const SizedBox(width: 3),
                              Text('Locked', style: AppText.mono(9, AppColors.textMuted)),
                            ])
                          else
                            Text('+${mission.xpReward} XP reward', style: AppText.mono(9, AppColors.textMuted)),
                        ],
                      ),
                    ],
                  ),
                ),

                if (isUnlocked && !isCompleted)
                  Icon(Icons.arrow_forward_ios_rounded, color: accent.withOpacity(0.5), size: 14),
                if (isCompleted)
                  Text(mission.badge.split(' ').last, style: const TextStyle(fontSize: 20)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
