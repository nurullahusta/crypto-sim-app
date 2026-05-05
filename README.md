# Cryptography & Network Security Simulator

An interactive mobile educational application built with **Flutter** that visually teaches how data travels over a network and demonstrates the importance of encryption through the **CIA Triad** (Confidentiality, Integrity, Authentication).

## Team

| Name | Role |
|------|------|
| **Nurullah Usta** | State & Logic Developer |
| **Arian Charkhchi** | UI/UX Developer |
| **Emre Ercan Güler** | Animations Developer |

## About

This simulator provides a hands-on learning experience for understanding core cryptographic concepts used in network security. Users can send messages between two parties (Alice and Bob) through a hostile network where a Man-in-the-Middle (MITM) attacker attempts to intercept the communication.

### Simulation Modes

| Mode | Protocol | What Happens |
|------|----------|-------------|
| **Plaintext** | HTTP | Message is sent as raw text — the hacker intercepts and reads everything |
| **Symmetric Key** | AES | Both parties share a secret key — the hacker sees only scrambled ciphertext |
| **Asymmetric Key** | RSA / HTTPS | Alice encrypts with Bob's public key — only Bob's private key can decrypt |

### Key Features

- **Three Visual Nodes** — Alice (Sender), Network/Hacker (MITM), and Bob (Receiver)
- **Animated Packet Traversal** — Watch data packets move across the network in real-time
- **Live Encryption Demo** — See plaintext transform into ciphertext with lock/unlock indicators
- **Hacker Interception** — Visual feedback showing what the attacker can and cannot read
- **Educational Notes** — Context-aware explanations grounded in real-world SOC/packet analysis concepts
- **SOC Terminal Aesthetic** — Dark mode UI with neon accents, scanline effects, and monospace typography

## Architecture

The project follows a **modular 3-file architecture** designed for parallel team development with minimal merge conflicts:

```
lib/
├── main.dart                          # App entry point, theme & Provider setup
└── crypto_simulator/
    ├── crypto_state.dart              # State management (ChangeNotifier)
    ├── crypto_ui.dart                 # UI layout & brutalist styling
    └── packet_animation.dart          # Animated widgets & custom painters
```

| File | Owner | Description |
|------|-------|-------------|
| `crypto_state.dart` | Nurullah Usta | Business logic, encryption simulation, phase management |
| `crypto_ui.dart` | Arian Charkhchi | Screen layout, input controls, terminal log, educational panels |
| `packet_animation.dart` | Emre Ercan Güler | Packet movement, wire painter, scanline overlay, glow effects |

## Design Language

**Digital Brutalism x SOC Terminal**

- **Background**: Deep black/charcoal (`#0A0A0A`)
- **Primary Accent**: Neon Green (`#00FF41`)
- **Warning Accent**: Bright Orange (`#FF6600`)
- **Danger Accent**: Red (`#FF3333`)
- **Typography**: Roboto Mono (monospace terminal feel)
- **Components**: Sharp edges, zero border-radius, visible borders, raw data presentation

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (3.0+)
- Android Studio / VS Code with Flutter extension
- An Android emulator or physical device

### Installation

```bash
# Clone the repository
git clone https://github.com/nurullahusta/crypto-sim-app.git

# Navigate to the project
cd crypto-sim-app

# Install dependencies
flutter pub get

# Run the app
flutter run
```

## Tech Stack

| Technology | Purpose |
|-----------|---------|
| Flutter | Cross-platform UI framework |
| Provider | State management |
| Google Fonts | Roboto Mono typography |
| CustomPainter | Wire and node animations |

## License

This project is developed for educational purposes as part of a Computer Networks course.
