import 'dart:math';
import 'package:flutter/foundation.dart';

// ─────────────────────────────────────────────────────────────
// FILE 1 OF 3 — STATE / LOGIC LAYER
// Owner : State & Logic Developer
// ─────────────────────────────────────────────────────────────

/// Supported encryption modes mapped to the CIA Triad concepts.
enum EncryptionType {
  plaintext,
  symmetricKey,
  asymmetricKey,
}

/// Simulation lifecycle.
enum SimulationPhase {
  idle,
  aliceEncrypting,
  transitToHacker,
  hackerInspecting,
  transitToBob,
  bobDecrypting,
  completed,
}

/// Holds all mutable state for the Crypto Simulator screen.
/// Consumed by the UI via [Provider] / [ChangeNotifier].
class CryptoState extends ChangeNotifier {
  // ── User Inputs ──────────────────────────────────────────
  String _message = '';
  EncryptionType _encryptionType = EncryptionType.plaintext;

  String get message => _message;
  EncryptionType get encryptionType => _encryptionType;

  void setMessage(String value) {
    _message = value;
    notifyListeners();
  }

  void setEncryptionType(EncryptionType value) {
    _encryptionType = value;
    // Reset simulation when mode changes.
    resetSimulation();
    notifyListeners();
  }

  // ── Simulation State ────────────────────────────────────
  SimulationPhase _phase = SimulationPhase.idle;
  SimulationPhase get phase => _phase;

  String _packetDisplay = '';
  String get packetDisplay => _packetDisplay;

  String _hackerInterceptedText = '';
  String get hackerInterceptedText => _hackerInterceptedText;

  String _bobDecryptedText = '';
  String get bobDecryptedText => _bobDecryptedText;

  String _statusLog = '[ READY ] Awaiting transmission…';
  String get statusLog => _statusLog;

  String _educationalNote = '';
  String get educationalNote => _educationalNote;

  bool get canSend =>
      _message.trim().isNotEmpty && _phase == SimulationPhase.idle;

  // ── Crypto helpers ──────────────────────────────────────
  static const String _symmetricKey = 'SHARED_KEY_128';
  static const String _publicKeyLabel = "Bob's Public Key (RSA‑2048)";
  static const String _privateKeyLabel = "Bob's Private Key";

  String get keyInfoLabel {
    switch (_encryptionType) {
      case EncryptionType.plaintext:
        return 'No encryption — raw HTTP';
      case EncryptionType.symmetricKey:
        return 'Shared Key: $_symmetricKey';
      case EncryptionType.asymmetricKey:
        return 'Encrypt: $_publicKeyLabel\nDecrypt: $_privateKeyLabel';
    }
  }

  /// Produces a deterministic‑looking scramble so the demo feels real.
  String _scramble(String input) {
    final rng = Random(input.hashCode);
    const chars = r'$%#@*!&^~?<>{}[]|+=';
    return String.fromCharCodes(
      List.generate(
        input.length,
        (_) => chars.codeUnitAt(rng.nextInt(chars.length)),
      ),
    );
  }

  // ── Simulation orchestration ────────────────────────────
  /// Launches the full send → intercept → receive pipeline.
  Future<void> startSimulation() async {
    if (!canSend) return;

    final raw = _message.trim();

    // Phase 1 — Alice encrypts
    _phase = SimulationPhase.aliceEncrypting;
    switch (_encryptionType) {
      case EncryptionType.plaintext:
        _packetDisplay = raw;
        _statusLog = '[ ALICE ] Sending plaintext over HTTP…';
        _educationalNote = '';
        break;
      case EncryptionType.symmetricKey:
        _packetDisplay = _scramble(raw);
        _statusLog =
            '[ ALICE ] Encrypting with symmetric key ($_symmetricKey)…';
        _educationalNote =
            'Symmetric encryption uses the SAME key on both sides.\n'
            'Fast, but key distribution is a risk — if the shared key leaks, all traffic is compromised.';
        break;
      case EncryptionType.asymmetricKey:
        _packetDisplay = _scramble(raw);
        _statusLog = "[ ALICE ] Encrypting with Bob's Public Key (RSA)…";
        _educationalNote =
            'Asymmetric (Public‑Key) encryption uses a KEY PAIR.\n'
            'Anyone can encrypt with the public key, but ONLY Bob can decrypt with his private key.\n'
            'This is the foundation of HTTPS / TLS.';
        break;
    }
    notifyListeners();

    // Phase 2 — Packet transits to hacker
    await Future.delayed(const Duration(milliseconds: 900));
    _phase = SimulationPhase.transitToHacker;
    _statusLog = '[ NET  ] Packet in transit — entering hostile network…';
    notifyListeners();

    // Phase 3 — Hacker inspects
    await Future.delayed(const Duration(milliseconds: 1100));
    _phase = SimulationPhase.hackerInspecting;

    switch (_encryptionType) {
      case EncryptionType.plaintext:
        _hackerInterceptedText = raw;
        _statusLog =
            '[ MITM ] ⚠ INTERCEPTED plaintext: "$raw"';
        _educationalNote =
            '🔴 CIA VIOLATION — Confidentiality BROKEN.\n'
            'In a real SOC, this would trigger an IDS alert.\n'
            'Plaintext HTTP exposes ALL data to anyone on the network path.';
        break;
      case EncryptionType.symmetricKey:
        _hackerInterceptedText = _packetDisplay;
        _statusLog =
            '[ MITM ] Intercepted ciphertext: "${_packetDisplay}" — cannot read!';
        _educationalNote =
            '🟢 Confidentiality PRESERVED.\n'
            'The hacker sees only scrambled bytes.\n'
            'Without the symmetric key, brute‑forcing AES‑128 would take billions of years.';
        break;
      case EncryptionType.asymmetricKey:
        _hackerInterceptedText = _packetDisplay;
        _statusLog =
            '[ MITM ] Intercepted ciphertext: "${_packetDisplay}" — RSA unbreakable!';
        _educationalNote =
            '🟢 Confidentiality + Authentication PRESERVED.\n'
            'RSA ciphertext is computationally infeasible to reverse without the private key.\n'
            'HTTPS negotiates this via the TLS handshake, which a SOC analyst can inspect in packet captures.';
        break;
    }
    notifyListeners();

    // Phase 4 — Packet transits to Bob
    await Future.delayed(const Duration(milliseconds: 1100));
    _phase = SimulationPhase.transitToBob;
    _statusLog = '[ NET  ] Packet leaving hostile zone → Bob…';
    notifyListeners();

    // Phase 5 — Bob decrypts
    await Future.delayed(const Duration(milliseconds: 900));
    _phase = SimulationPhase.bobDecrypting;

    switch (_encryptionType) {
      case EncryptionType.plaintext:
        _bobDecryptedText = raw;
        _statusLog = '[ BOB  ] Received plaintext: "$raw"';
        break;
      case EncryptionType.symmetricKey:
        _bobDecryptedText = raw;
        _statusLog =
            '[ BOB  ] Decrypted with shared key → "$raw"';
        break;
      case EncryptionType.asymmetricKey:
        _bobDecryptedText = raw;
        _statusLog =
            '[ BOB  ] Decrypted with Private Key → "$raw"';
        break;
    }
    notifyListeners();

    // Phase 6 — Done
    await Future.delayed(const Duration(milliseconds: 600));
    _phase = SimulationPhase.completed;
    _statusLog = '[ DONE ] Transmission complete. Review the log above.';
    notifyListeners();
  }

  void resetSimulation() {
    _phase = SimulationPhase.idle;
    _packetDisplay = '';
    _hackerInterceptedText = '';
    _bobDecryptedText = '';
    _statusLog = '[ READY ] Awaiting transmission…';
    _educationalNote = '';
    notifyListeners();
  }
}
