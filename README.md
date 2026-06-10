# Operation CryptoBreak

Operation CryptoBreak is an interactive, spy-themed educational mobile application designed to teach cryptography concepts to middle school students. Through a series of five tactical agent missions, students decrypt enemy communications, crack codes using various historic ciphers, and learn fundamental principles of data security.

## Missions

| Mission | Cipher | XP Reward | Difficulty |
| :--- | :--- | :--- | :--- |
| **Mission 0** — Caesar Cipher | Shift Cipher | 100 XP | ⭐ (Easy) |
| **Mission 1** — Brute Force | Caesar Key cracking | 150 XP | ⭐⭐ (Easy) |
| **Mission 2** — Vigenère | Polyalphabetic Substitution | 200 XP | ⭐⭐⭐ (Medium) |
| **Mission 3** — Asymmetric | Public/Private Key pair | 250 XP | ⭐⭐⭐⭐ (Hard) |
| **Mission 4** — Hashing | SHA-256 Fingerprinting | 300 XP | ⭐⭐⭐⭐⭐ (Expert) |

## Getting Started

### Prerequisites
- Flutter SDK `>= 3.0.0`
- Dart SDK `>= 3.0.0 < 4.0.0`

### Installation & Execution
1. Clone the repository:
   ```bash
   git clone https://github.com/nurullahusta/crypto-sim-app.git
   ```
2. Navigate to the project directory:
   ```bash
   cd crypto-sim-app
   ```
3. Fetch application dependencies:
   ```bash
   flutter pub get
   ```
4. Run the application on a connected device or emulator:
   ```bash
   flutter run
   ```

## Architecture

The project follows a clean, decoupled 4-layer structural design:

- **`lib/game/`** — Core domain logic, state management (`GameState` ChangeNotifier), models, and cipher algorithms. This layer has zero dependencies on Flutter UI components (only imports `package:flutter/foundation.dart`).
- **`lib/app/`** — Central configuration layer housing the unified cryptographic Design System (`theme.dart`) and standard navigator routing configurations (`router.dart`).
- **`lib/screens/`** — Main screen pages of the application (`onboarding_screen.dart`, `mission_map_screen.dart`, and `mission_screen.dart` which implements the Briefing → Puzzle → Reveal state machine).
- **`lib/widgets/`** — Reusable, context-specific puzzle widgets and shared UI layout containers tailored to each cryptographic technique.

## License

This project is licensed under the [MIT License](LICENSE).
