import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app/theme.dart';
import '../game/game_state.dart';

// =============================================================================
// SECTION: Onboarding Screen — Agent Registration
// =============================================================================

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final _controller = TextEditingController();
  final _formKey    = GlobalKey<FormState>();
  late AnimationController _fadeCtrl;
  late Animation<double>   _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _confirm() {
    if (_controller.text.trim().isEmpty) return;
    context.read<GameState>().setAgentName(_controller.text.trim());
    Navigator.pushReplacementNamed(context, '/map');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                // ── Logo / Icon ───────────────────────────────────────────
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.cyanDim,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.cyan, width: 2),
                    boxShadow: [BoxShadow(color: AppColors.cyanGlow, blurRadius: 24)],
                  ),
                  child: const Center(
                    child: Text('🕵️', style: TextStyle(fontSize: 36)),
                  ),
                ),
                const SizedBox(height: 28),

                // ── Title ─────────────────────────────────────────────────
                Text(
                  'CRYPTOHQ',
                  style: AppText.mono(28, AppColors.cyan, FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  'Operation CryptoBreak',
                  style: AppText.heading(18, AppColors.textPrimary),
                ),
                const SizedBox(height: 16),

                // ── Description ───────────────────────────────────────────
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.bgCard,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderDefault),
                  ),
                  child: Text(
                    'Agent, we have intercepted a series of encrypted enemy communications. '
                    'Your mission: crack the codes, learn the secrets, and protect the operation.\n\n'
                    '5 missions. 5 cipher techniques. The world\'s security depends on you.',
                    style: AppText.body(14, AppColors.textSecondary),
                  ),
                ),
                const SizedBox(height: 32),

                // ── Agent Name Input ──────────────────────────────────────
                Text(
                  'ENTER YOUR AGENT NAME',
                  style: AppText.mono(10, AppColors.cyan, FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _controller,
                  style: AppText.mono(16, AppColors.textPrimary),
                  cursorColor: AppColors.cyan,
                  textCapitalization: TextCapitalization.words,
                  onSubmitted: (_) => _confirm(),
                  decoration: InputDecoration(
                    hintText: 'e.g. Shadow Fox',
                    hintStyle: AppText.mono(14, AppColors.textMuted),
                    prefixIcon: const Icon(Icons.person_outline_rounded, color: AppColors.cyan, size: 20),
                    filled: true,
                    fillColor: AppColors.bgCard,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.borderDefault),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.cyan, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
                const SizedBox(height: 20),

                // ── Begin Button ──────────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: _confirm,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.cyan.withOpacity(0.3), AppColors.cyan.withOpacity(0.1)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.cyan, width: 2),
                        boxShadow: [BoxShadow(color: AppColors.cyanGlow, blurRadius: 16)],
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('BEGIN MISSION  ', style: AppText.mono(15, AppColors.cyan, FontWeight.bold)),
                          const Icon(Icons.arrow_forward_rounded, color: AppColors.cyan, size: 18),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // ── Progress badges row ───────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _badge('5', 'Missions'),
                    const SizedBox(width: 20),
                    _badge('5', 'Ciphers'),
                    const SizedBox(width: 20),
                    _badge('800', 'Max XP'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _badge(String value, String label) {
    return Column(
      children: [
        Text(value, style: AppText.mono(18, AppColors.cyan, FontWeight.bold)),
        Text(label, style: AppText.mono(9, AppColors.textMuted)),
      ],
    );
  }
}
