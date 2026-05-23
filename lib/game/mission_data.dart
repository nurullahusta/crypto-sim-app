import 'package:flutter/material.dart';
import 'game_state.dart';

// =============================================================================
// SECTION: Mission Data — All 5 Missions Defined
// =============================================================================

class Mission {
  final int id;
  final String codename;
  final String title;
  final String emoji;
  final Color accentColor;
  final int difficulty;   // 1-5 stars
  final int xpReward;
  final String badge;
  final String briefing;   // Story shown before puzzle
  final PuzzleType puzzleType;
  final String revelation; // Educational note shown after solving

  const Mission({
    required this.id,
    required this.codename,
    required this.title,
    required this.emoji,
    required this.accentColor,
    required this.difficulty,
    required this.xpReward,
    required this.badge,
    required this.briefing,
    required this.puzzleType,
    required this.revelation,
  });
}

class MissionCatalog {
  MissionCatalog._();

  static const List<Mission> all = [

    // ── Mission 0: Caesar Cipher ──────────────────────────────────────────
    Mission(
      id: 0,
      codename: 'OPERATION CAESAR',
      title: 'The First Code',
      emoji: '⚔️',
      accentColor: Color(0xFFFF8800),
      difficulty: 1,
      xpReward: 100,
      badge: 'Caesar Cracker ⚔️',
      briefing:
          'Welcome to CryptoHQ, Agent.\n\n'
          'Our field operative intercepted a message from an enemy agent just minutes ago. '
          'Intelligence believes it is encrypted using a Caesar cipher — one of the oldest '
          'codes in human history, used by Julius Caesar himself 2,000 years ago.\n\n'
          'In a Caesar cipher, every letter is shifted forward by a fixed number in the alphabet. '
          'For example, with shift 3: A → D, B → E, C → F.\n\n'
          'The message reads:\n'
          '"DWWDFN DW GDZQ"\n\n'
          'Your mission: find the correct shift and decode the message. Lives depend on it.',
      puzzleType: PuzzleType.caesar,
      revelation:
          '🔍 DEBRIEF\n\n'
          'Excellent work, Agent! The Caesar cipher uses a single number (the "shift") as its key.\n\n'
          '• Encrypt: shift each letter forward\n'
          '• Decrypt: shift each letter backward\n\n'
          'With 26 letters, there are only 25 possible keys. A human can try all of them by hand '
          'in minutes. A computer can crack it in microseconds — making the Caesar cipher completely '
          'insecure by modern standards.\n\n'
          'It was good enough for Caesar\'s time when most people couldn\'t even read. '
          'But the world has changed. We need stronger methods.',
    ),

    // ── Mission 1: Brute Force ────────────────────────────────────────────
    Mission(
      id: 1,
      codename: 'OPERATION BRUTE',
      title: 'No Key, No Problem',
      emoji: '💥',
      accentColor: Color(0xFFFF3366),
      difficulty: 2,
      xpReward: 150,
      badge: 'Brute Force Expert 💥',
      briefing:
          'We intercepted another message from the same enemy network, Agent.\n\n'
          'This time our informant tells us it\'s Caesar-encoded — but they don\'t know the shift. '
          'No key. No hint.\n\n'
          'The message:\n'
          '"WYVALK AOL RLF"\n\n'
          'Your mission: try all 25 possible shifts. Find the one that produces a real English message. '
          'This technique is called a Brute Force Attack — trying every possible key until one works.\n\n'
          'Scroll through all the decoded options below. When you spot the real message, tap it.',
      puzzleType: PuzzleType.bruteForce,
      revelation:
          '🔍 DEBRIEF\n\n'
          'You just performed a brute-force attack — and it was trivially easy!\n\n'
          'The Caesar cipher\'s fatal flaw: it has only 25 possible keys. '
          'A modern computer can try all of them in less than 1 millisecond.\n\n'
          'Real encryption needs astronomically more possible keys. '
          'AES-256 has 2²⁵⁶ possible keys — more than the number of atoms in the observable universe. '
          'Even all computers on Earth working together couldn\'t brute-force it in the age of the universe.\n\n'
          'Key lesson: security comes from having too many possibilities to try.',
    ),

    // ── Mission 2: Vigenère / Symmetric Key ──────────────────────────────
    Mission(
      id: 2,
      codename: 'OPERATION KEYLOCK',
      title: 'The Shared Password',
      emoji: '🗝️',
      accentColor: Color(0xFF00FF88),
      difficulty: 3,
      xpReward: 200,
      badge: 'Key Keeper 🗝️',
      briefing:
          'Agent, we\'ve intercepted a message sent between two enemy operatives.\n\n'
          'This time they\'re using something stronger: a Vigenère cipher. Unlike Caesar\'s single shift, '
          'this cipher uses a whole keyword. Each letter of the keyword gives a different shift — '
          'making it much harder to crack by brute force.\n\n'
          'Our double agent inside their network has passed us the key: "MOON"\n\n'
          'The encrypted message:\n'
          '"YAEQ AE TBER"\n\n'
          'Type the keyword in the box below. Watch the message decrypt in real time. '
          'When you see the real message, tap CONFIRM.',
      puzzleType: PuzzleType.vigenere,
      revelation:
          '🔍 DEBRIEF\n\n'
          'The Vigenère cipher uses a keyword to apply different shifts to each letter — '
          'much stronger than Caesar.\n\n'
          'This is the idea behind modern Symmetric Encryption:\n'
          '• The SAME key is used to both encrypt and decrypt\n'
          '• Alice and Bob must both secretly have the key\n'
          '• AES (Advanced Encryption Standard) uses this principle with keys up to 256 bits long\n\n'
          'The BIG problem: How do Alice and Bob share the key safely without an attacker intercepting it?\n\n'
          'Our double agent had to physically deliver the key in person. '
          'In the digital world, we need a smarter solution — and that\'s what the next mission is about.',
    ),

    // ── Mission 3: Asymmetric / Public Key ───────────────────────────────
    Mission(
      id: 3,
      codename: 'OPERATION KEYPAIR',
      title: 'The Magic Lock',
      emoji: '🔑',
      accentColor: Color(0xFFAA44FF),
      difficulty: 4,
      xpReward: 250,
      badge: 'Key Pair Master 🔑',
      briefing:
          'Agent, we need to send a secret message to our operative in the field — Agent Bob.\n\n'
          'The problem: we\'ve never met Bob in person. We have NO shared secret key. '
          'Anyone could be monitoring the channel.\n\n'
          'Bob solved this by posting his PUBLIC KEY on a public notice board — visible to everyone, '
          'including the enemy. But that\'s the clever part:\n\n'
          '• Anyone can ENCRYPT a message with Bob\'s public key\n'
          '• ONLY Bob can DECRYPT it with his private key (which he never shares)\n\n'
          'It\'s like a padlock: Bob hands out open padlocks to everyone. '
          'You snap your message inside and lock it. Only Bob has the key to open it.\n\n'
          'Answer the questions below to prove you understand how this works.',
      puzzleType: PuzzleType.asymmetric,
      revelation:
          '🔍 DEBRIEF\n\n'
          'You\'ve just learned the concept behind Public-Key Cryptography (Asymmetric Encryption).\n\n'
          '• Public Key → Encrypts (anyone can use it)\n'
          '• Private Key → Decrypts (only the owner has it)\n\n'
          'RSA, invented in 1977, is based on a math fact: '
          'multiplying two huge prime numbers is fast, but factoring the result back is nearly impossible.\n\n'
          'Every time you see 🔒 in a browser: that\'s asymmetric encryption at work. '
          'The TLS handshake uses RSA or ECDH to safely exchange a symmetric session key — '
          'combining the best of both worlds.',
    ),

    // ── Mission 4: Hashing ────────────────────────────────────────────────
    Mission(
      id: 4,
      codename: 'OPERATION HASHMARK',
      title: 'Tampered Evidence',
      emoji: '#️⃣',
      accentColor: Color(0xFFFFD700),
      difficulty: 5,
      xpReward: 300,
      badge: 'Hash Detective #️⃣',
      briefing:
          'Final mission, Agent. This one is critical.\n\n'
          'HQ sent you a classified document over an insecure channel. '
          'We suspect the enemy intercepted it and changed a word before forwarding it.\n\n'
          'HQ also sent the SHA-256 hash of the ORIGINAL document. '
          'A hash is like a digital fingerprint — if even ONE character changes, '
          'the entire hash completely changes.\n\n'
          'Compare the hash of the received document with the original hash. '
          'If they match: the document is authentic. If they don\'t: it was tampered with.\n\n'
          'Determine whether the received document has been modified.',
      puzzleType: PuzzleType.hashing,
      revelation:
          '🔍 DEBRIEF\n\n'
          'You\'ve discovered the power of Hash Functions — the guardians of data integrity.\n\n'
          'Key properties of a good hash:\n'
          '• One-way: you cannot reverse it to get the original\n'
          '• Deterministic: same input always → same hash\n'
          '• Avalanche effect: one character change → completely different hash\n'
          '• Collision-resistant: practically impossible for two inputs to share a hash\n\n'
          'Real uses:\n'
          '• Storing passwords (websites never store your actual password)\n'
          '• Verifying software downloads (checksums)\n'
          '• Digital signatures\n'
          '• Blockchain / cryptocurrency\n\n'
          'Congratulations, Master Cryptographer. You\'ve completed all missions. '
          'The world is a safer place thanks to you.',
    ),
  ];

  static Mission byId(int id) => all[id];
}
