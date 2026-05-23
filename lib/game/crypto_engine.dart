import 'dart:convert';
import 'dart:math';

// =============================================================================
// SECTION: Crypto Engine — All Cipher Logic Used by Puzzles
// =============================================================================

class CryptoEngine {
  CryptoEngine._();

  // ── Caesar Cipher ──────────────────────────────────────────────────────────

  static String caesarDecrypt(String ciphertext, int shift) {
    shift = ((shift % 26) + 26) % 26;
    final buf = StringBuffer();
    for (final ch in ciphertext.runes) {
      if (ch >= 65 && ch <= 90) {
        buf.writeCharCode((ch - 65 - shift + 26) % 26 + 65);
      } else if (ch >= 97 && ch <= 122) {
        buf.writeCharCode((ch - 97 - shift + 26) % 26 + 97);
      } else {
        buf.writeCharCode(ch);
      }
    }
    return buf.toString();
  }

  static String caesarEncrypt(String text, int shift) =>
      caesarDecrypt(text, -shift);

  /// Returns all 25 possible decryptions as (shift, text) pairs.
  static List<MapEntry<int, String>> allCaesarShifts(String ciphertext) {
    return List.generate(25, (i) {
      final s = i + 1;
      return MapEntry(s, caesarDecrypt(ciphertext, s));
    });
  }

  // ── Vigenère Cipher ─────────────────────────────────────────────────────

  static String vigenereDecrypt(String ciphertext, String key) {
    if (key.isEmpty) return ciphertext;
    final k = key.toUpperCase().replaceAll(RegExp(r'[^A-Z]'), '');
    if (k.isEmpty) return ciphertext;
    final buf = StringBuffer();
    int ki = 0;
    for (final ch in ciphertext.runes) {
      if (ch >= 65 && ch <= 90) {
        final shift = k.codeUnitAt(ki % k.length) - 65;
        buf.writeCharCode((ch - 65 - shift + 26) % 26 + 65);
        ki++;
      } else if (ch >= 97 && ch <= 122) {
        final shift = k.codeUnitAt(ki % k.length) - 65;
        buf.writeCharCode((ch - 97 - shift + 26) % 26 + 97);
        ki++;
      } else {
        buf.writeCharCode(ch);
      }
    }
    return buf.toString();
  }

  // ── Educational Hash (FNV-1a based) ──────────────────────────────────────

  static String hash(String input) {
    const fnvPrime = 0x01000193;
    const basis    = 0x811c9dc5;
    int h = basis;
    for (final byte in utf8.encode(input)) {
      h ^= byte;
      h  = (h * fnvPrime) & 0xFFFFFFFF;
    }
    final h1 = h.toRadixString(16).padLeft(8, '0');
    final h2 = (h ^ 0xDEADBEEF).toRadixString(16).padLeft(8, '0');
    final h3 = (h ^ 0xCAFEBABE).toRadixString(16).padLeft(8, '0');
    final h4 = (h ^ 0xFACEFEED).toRadixString(16).padLeft(8, '0');
    return '$h1$h2$h3$h4';
  }

  // ── Answer Validators (used by puzzle widgets) ────────────────────────────

  /// Mission 1: correct shift for the Caesar puzzle is 3.
  static const int mission1CorrectShift = 3;
  static const String mission1Ciphertext = 'DWWDFN DW GDZQ';
  static const String mission1Answer = 'ATTACK AT DAWN';

  /// Mission 2: correct shift is 7 ("PROTECT THE KEY").
  static const int mission2CorrectShift = 7;
  static const String mission2Ciphertext = 'WYVALK AOL RLF';
  static const String mission2Answer = 'PROTECT THE KEY';

  /// Mission 3: Vigenère key is "MOON".
  static const String mission3Key      = 'MOON';
  static const String mission3Cipher   = 'YAEQ AE TBER';
  static const String mission3Answer   = 'MEET AT BASE';

  /// Mission 4: asymmetric quiz — correctIndex per question.
  static const List<int> mission4CorrectIndices = [1, 0, 2];

  /// Mission 5: original message and tampered message.
  static const String mission5Original  = 'Meet at the bridge at midnight.';
  static const String mission5Tampered  = 'Meet at the bridge at midday.';
}
