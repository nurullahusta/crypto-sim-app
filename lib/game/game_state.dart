import 'package:flutter/foundation.dart';

// =============================================================================
// SECTION: Enums — Mission & Game Phase Definitions
// =============================================================================

enum MissionPhase { briefing, puzzle, reveal }

enum PuzzleType { caesar, bruteForce, vigenere, asymmetric, hashing }

// =============================================================================
// SECTION: GameState — Central State for the Entire Game
// =============================================================================

class GameState extends ChangeNotifier {
  // ── Agent Profile ─────────────────────────────────────────────────────────

  String _agentName = '';
  String get agentName => _agentName;

  bool get hasAgent => _agentName.isNotEmpty;

  void setAgentName(String name) {
    _agentName = name.trim();
    notifyListeners();
  }

  // ── XP & Rank ─────────────────────────────────────────────────────────────

  int _xp = 0;
  int get xp => _xp;

  void addXp(int amount) {
    _xp += amount;
    notifyListeners();
  }

  String get agentRank {
    if (_xp < 100)  return 'Recruit';
    if (_xp < 250)  return 'Field Agent';
    if (_xp < 450)  return 'Senior Agent';
    if (_xp < 700)  return 'Special Agent';
    return 'Master Cryptographer';
  }

  String get rankIcon {
    if (_xp < 100)  return '🔰';
    if (_xp < 250)  return '🕵️';
    if (_xp < 450)  return '🏅';
    if (_xp < 700)  return '⭐';
    return '🏆';
  }

  // ── Mission Progress ──────────────────────────────────────────────────────

  /// Set of mission IDs the player has fully completed.
  final Set<int> _completedMissions = {};
  Set<int> get completedMissions => Set.unmodifiable(_completedMissions);

  bool isMissionCompleted(int id) => _completedMissions.contains(id);

  /// A mission is unlocked if it is mission 0, or the previous one is done.
  bool isMissionUnlocked(int id) {
    if (id == 0) return true;
    return _completedMissions.contains(id - 1);
  }

  void completeMission(int missionId, int xpReward) {
    if (!_completedMissions.contains(missionId)) {
      _completedMissions.add(missionId);
      addXp(xpReward);
    }
    notifyListeners();
  }

  // ── Active Mission Phase ──────────────────────────────────────────────────

  int _activeMissionId = -1;
  int get activeMissionId => _activeMissionId;

  MissionPhase _phase = MissionPhase.briefing;
  MissionPhase get phase => _phase;

  void startMission(int id) {
    _activeMissionId = id;
    _phase = MissionPhase.briefing;
    notifyListeners();
  }

  void advanceToPuzzle() {
    _phase = MissionPhase.puzzle;
    notifyListeners();
  }

  void advanceToReveal(int missionId, int xpReward) {
    completeMission(missionId, xpReward);
    _phase = MissionPhase.reveal;
    notifyListeners();
  }

  void exitMission() {
    _activeMissionId = -1;
    _phase = MissionPhase.briefing;
    notifyListeners();
  }

  // ── Stats ─────────────────────────────────────────────────────────────────

  int get totalMissions => 5;
  int get completedCount => _completedMissions.length;
  bool get isGameComplete => _completedMissions.length >= totalMissions;

  double get overallProgress => completedCount / totalMissions;
}
