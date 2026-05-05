import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'crypto_state.dart';
import 'packet_animation.dart';

// ─────────────────────────────────────────────────────────────
// FILE 2 OF 3 — UI / LAYOUT LAYER
// Owner : UI Developer
// ─────────────────────────────────────────────────────────────

// ── Color constants (SOC Terminal / Digital Brutalism) ─────
class Soc {
  Soc._();
  static const bg = Color(0xFF0A0A0A);
  static const surface = Color(0xFF141414);
  static const border = Color(0xFF2A2A2A);
  static const green = Color(0xFF00FF41);
  static const orange = Color(0xFFFF6600);
  static const red = Color(0xFFFF3333);
  static const dimGreen = Color(0xFF0D3B15);
  static const dimOrange = Color(0xFF3B2200);
  static const white = Color(0xFFE0E0E0);
  static const muted = Color(0xFF666666);
}

/// The top‑level screen for the Cryptography & Network Security Simulator.
class CryptoSimulatorScreen extends StatelessWidget {
  const CryptoSimulatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Soc.bg,
      body: ScanlineOverlay(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildNodesRow(context),
                      const SizedBox(height: 4),
                      _buildPacketLane(context),
                      const SizedBox(height: 16),
                      _buildControlPanel(context),
                      const SizedBox(height: 16),
                      _buildTerminalLog(context),
                      const SizedBox(height: 12),
                      _buildEducationalNote(context),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Soc.surface,
        border: Border(bottom: BorderSide(color: Soc.green, width: 1)),
      ),
      child: Row(
        children: [
          const Icon(Icons.shield, color: Soc.green, size: 22),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CRYPTO & NETWORK SECURITY SIMULATOR',
                  style: _mono(13, Soc.green, FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  'CIA Triad — Confidentiality · Integrity · Authentication',
                  style: _mono(9, Soc.muted),
                ),
              ],
            ),
          ),
          const BlinkingCursor(),
        ],
      ),
    );
  }

  // ── Three visual nodes ────────────────────────────────
  Widget _buildNodesRow(BuildContext context) {
    final state = context.watch<CryptoState>();

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        children: [
          Expanded(child: _nodeCard('ALICE', 'Sender', Icons.person, Soc.green, state)),
          const SizedBox(width: 8),
          Expanded(
            child: _nodeCard(
              'MITM',
              'Hacker / Network',
              Icons.warning_amber_rounded,
              Soc.orange,
              state,
              isMitm: true,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: _nodeCard('BOB', 'Receiver', Icons.person, Soc.green, state, isBob: true)),
        ],
      ),
    );
  }

  Widget _nodeCard(
    String label,
    String subtitle,
    IconData icon,
    Color accent,
    CryptoState state, {
    bool isMitm = false,
    bool isBob = false,
  }) {
    // Determine if node is "active" based on phase
    bool active = false;
    String? extraText;

    switch (state.phase) {
      case SimulationPhase.aliceEncrypting:
        active = !isMitm && !isBob;
        break;
      case SimulationPhase.hackerInspecting:
        active = isMitm;
        if (isMitm) extraText = state.hackerInterceptedText;
        break;
      case SimulationPhase.bobDecrypting:
      case SimulationPhase.completed:
        active = isBob;
        if (isBob) extraText = state.bobDecryptedText;
        break;
      default:
        break;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: active ? accent.withOpacity(0.08) : Soc.surface,
        border: Border.all(
          color: active ? accent : Soc.border,
          width: active ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: accent, size: 28),
          const SizedBox(height: 4),
          Text(label, style: _mono(12, accent, FontWeight.bold)),
          Text(subtitle, style: _mono(8, Soc.muted), textAlign: TextAlign.center),
          if (extraText != null && extraText.isNotEmpty) ...[
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(4),
              color: Soc.bg,
              child: Text(
                extraText,
                style: _mono(
                  9,
                  isMitm
                      ? (state.encryptionType == EncryptionType.plaintext
                          ? Soc.red
                          : Soc.orange)
                      : Soc.green,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ── Packet animation lane ─────────────────────────────
  Widget _buildPacketLane(BuildContext context) {
    final state = context.watch<CryptoState>();
    return PacketAnimationWidget(
      phase: state.phase,
      displayText: state.packetDisplay,
      isEncrypted: state.encryptionType != EncryptionType.plaintext,
    );
  }

  // ── Control panel ─────────────────────────────────────
  Widget _buildControlPanel(BuildContext context) {
    final state = context.watch<CryptoState>();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Soc.surface,
        border: Border.all(color: Soc.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Section label
          Row(
            children: [
              const Icon(Icons.terminal, color: Soc.green, size: 16),
              const SizedBox(width: 6),
              Text('CONTROL PANEL', style: _mono(11, Soc.green, FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),

          // Message input
          Text('> MESSAGE:', style: _mono(10, Soc.muted)),
          const SizedBox(height: 4),
          TextField(
            onChanged: state.setMessage,
            enabled: state.phase == SimulationPhase.idle,
            style: _mono(13, Soc.white),
            cursorColor: Soc.green,
            decoration: InputDecoration(
              hintText: 'Enter secret message…',
              hintStyle: _mono(12, Soc.muted),
              filled: true,
              fillColor: Soc.bg,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: Soc.green, width: 1),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: Soc.green, width: 2),
              ),
              disabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: Soc.border, width: 1),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Encryption type selector
          Text('> ENCRYPTION:', style: _mono(10, Soc.muted)),
          const SizedBox(height: 4),
          _buildEncryptionSelector(state),
          const SizedBox(height: 8),

          // Key info
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            color: Soc.bg,
            child: Text(
              state.keyInfoLabel,
              style: _mono(9, Soc.muted),
            ),
          ),
          const SizedBox(height: 12),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: _brutalistButton(
                  label: '▶  SEND PACKET',
                  color: Soc.green,
                  onTap: state.canSend ? () => state.startSimulation() : null,
                ),
              ),
              const SizedBox(width: 8),
              _brutalistButton(
                label: '↺  RESET',
                color: Soc.orange,
                onTap: state.phase != SimulationPhase.idle
                    ? () => state.resetSimulation()
                    : null,
                compact: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEncryptionSelector(CryptoState state) {
    return Row(
      children: [
        _encryptionChip(
          label: 'HTTP',
          value: EncryptionType.plaintext,
          state: state,
          color: Soc.red,
        ),
        const SizedBox(width: 6),
        _encryptionChip(
          label: 'SYMMETRIC',
          value: EncryptionType.symmetricKey,
          state: state,
          color: Soc.green,
        ),
        const SizedBox(width: 6),
        _encryptionChip(
          label: 'ASYMMETRIC',
          value: EncryptionType.asymmetricKey,
          state: state,
          color: Soc.green,
        ),
      ],
    );
  }

  Widget _encryptionChip({
    required String label,
    required EncryptionType value,
    required CryptoState state,
    required Color color,
  }) {
    final selected = state.encryptionType == value;
    final enabled = state.phase == SimulationPhase.idle;

    return Expanded(
      child: GestureDetector(
        onTap: enabled ? () => state.setEncryptionType(value) : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: selected ? color.withOpacity(0.15) : Soc.bg,
            border: Border.all(
              color: selected ? color : Soc.border,
              width: selected ? 2 : 1,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: _mono(
              9,
              selected ? color : Soc.muted,
              selected ? FontWeight.bold : FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _brutalistButton({
    required String label,
    required Color color,
    VoidCallback? onTap,
    bool compact = false,
  }) {
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(
          vertical: compact ? 10 : 14,
          horizontal: compact ? 12 : 0,
        ),
        decoration: BoxDecoration(
          color: enabled ? color.withOpacity(0.12) : Soc.surface,
          border: Border.all(
            color: enabled ? color : Soc.border,
            width: 2,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: _mono(
            11,
            enabled ? color : Soc.muted,
            FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // ── Terminal log ──────────────────────────────────────
  Widget _buildTerminalLog(BuildContext context) {
    final state = context.watch<CryptoState>();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Soc.bg,
        border: Border.all(color: Soc.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('┌─ TERMINAL LOG', style: _mono(10, Soc.muted)),
              const Spacer(),
              Text(_phaseTag(state.phase), style: _mono(9, Soc.orange)),
            ],
          ),
          const SizedBox(height: 6),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Text(
              state.statusLog,
              key: ValueKey(state.statusLog),
              style: _mono(
                11,
                state.encryptionType == EncryptionType.plaintext &&
                        (state.phase == SimulationPhase.hackerInspecting ||
                            state.phase == SimulationPhase.completed)
                    ? Soc.red
                    : Soc.green,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text('└─', style: _mono(10, Soc.muted)),
        ],
      ),
    );
  }

  String _phaseTag(SimulationPhase p) {
    switch (p) {
      case SimulationPhase.idle:
        return 'IDLE';
      case SimulationPhase.aliceEncrypting:
        return 'ENCRYPTING';
      case SimulationPhase.transitToHacker:
        return 'IN TRANSIT';
      case SimulationPhase.hackerInspecting:
        return 'MITM INSPECT';
      case SimulationPhase.transitToBob:
        return 'IN TRANSIT';
      case SimulationPhase.bobDecrypting:
        return 'DECRYPTING';
      case SimulationPhase.completed:
        return 'COMPLETE';
    }
  }

  // ── Educational note ──────────────────────────────────
  Widget _buildEducationalNote(BuildContext context) {
    final state = context.watch<CryptoState>();
    if (state.educationalNote.isEmpty) return const SizedBox.shrink();

    final isVulnerable = state.encryptionType == EncryptionType.plaintext;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Container(
        key: ValueKey(state.educationalNote),
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isVulnerable ? Soc.dimOrange : Soc.dimGreen,
          border: Border(
            left: BorderSide(
              color: isVulnerable ? Soc.orange : Soc.green,
              width: 3,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isVulnerable ? Icons.warning : Icons.school,
                  color: isVulnerable ? Soc.orange : Soc.green,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  isVulnerable ? 'SECURITY ALERT' : 'LEARNING NOTE',
                  style: _mono(
                    10,
                    isVulnerable ? Soc.orange : Soc.green,
                    FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              state.educationalNote,
              style: _mono(10, Soc.white),
            ),
          ],
        ),
      ),
    );
  }

  // ── Typography helper ─────────────────────────────────
  static TextStyle _mono(double size, Color color, [FontWeight? weight]) {
    return TextStyle(
      fontFamily: 'RobotoMono',
      fontSize: size,
      color: color,
      fontWeight: weight ?? FontWeight.normal,
      height: 1.4,
    );
  }
}
