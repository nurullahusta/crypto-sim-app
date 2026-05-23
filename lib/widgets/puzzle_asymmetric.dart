import 'package:flutter/material.dart';
import '../app/theme.dart';
import 'puzzle_shared.dart';

// =============================================================================
// SECTION: Puzzle — Mission 3: Asymmetric Encryption (Concept MCQ)
// =============================================================================

class PuzzleAsymmetric extends StatefulWidget {
  final VoidCallback onSolved;
  const PuzzleAsymmetric({super.key, required this.onSolved});

  @override
  State<PuzzleAsymmetric> createState() => _PuzzleAsymmetricState();
}

class _PuzzleAsymmetricState extends State<PuzzleAsymmetric> {
  // Questions: index of correct answer for each
  static const _questions = [
    _AQuestion(
      question: 'You want to send Agent Bob a secret message. Which key do you use to encrypt?',
      options: ["Your own private key", "Bob's public key", "A shared password", "Bob's private key"],
      correctIndex: 1,
    ),
    _AQuestion(
      question: 'Bob receives the encrypted message. Which key does he use to decrypt it?',
      options: ["His public key", "Your public key", "His private key", "A shared password"],
      correctIndex: 2,
    ),
    _AQuestion(
      question: 'Alice signs a document to prove it came from her. She encrypts the signature with:',
      options: ["Bob's public key", "Her public key", "Her private key", "A random key"],
      correctIndex: 2,
    ),
  ];

  final List<int?> _answers = [null, null, null];
  int _currentQ = 0;
  bool _showWrong = false;

  void _selectAnswer(int index) {
    if (_answers[_currentQ] != null) return; // already answered
    final correct = _questions[_currentQ].correctIndex == index;
    setState(() => _answers[_currentQ] = index);
    if (correct) {
      Future.delayed(const Duration(milliseconds: 600), () {
        if (!mounted) return;
        if (_currentQ < _questions.length - 1) {
          setState(() => _currentQ++);
        } else {
          // All answered correctly
          Future.delayed(const Duration(milliseconds: 400), widget.onSolved);
        }
      });
    } else {
      setState(() => _showWrong = true);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() { _showWrong = false; _answers[_currentQ] = null; });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const accent = AppColors.purple;
    final q = _questions[_currentQ];
    final answered = _answers[_currentQ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Progress
        Row(
          children: List.generate(_questions.length, (i) {
            Color c;
            if (i < _currentQ) c = accent;
            else if (i == _currentQ) c = accent.withOpacity(0.5);
            else c = AppColors.borderDefault;
            return Expanded(
              child: Container(
                height: 4,
                margin: EdgeInsets.only(right: i < _questions.length - 1 ? 4 : 0),
                decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(2)),
              ),
            );
          }),
        ),
        const SizedBox(height: 4),
        Text('Question ${_currentQ + 1} of ${_questions.length}',
            style: AppText.mono(9, AppColors.textMuted), textAlign: TextAlign.right),
        const SizedBox(height: 16),

        // Mailbox diagram
        _MailboxDiagram(),
        const SizedBox(height: 16),

        // Question
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: accent.withOpacity(0.3)),
          ),
          child: Text(q.question, style: AppText.body(14, AppColors.textPrimary)),
        ),
        const SizedBox(height: 14),

        if (_showWrong) ...[
          PuzzleFeedback(message: 'Wrong! Think about who needs to be able to decrypt the message.', color: AppColors.red),
          const SizedBox(height: 8),
        ],

        // Options
        ...q.options.asMap().entries.map((e) {
          final i = e.key;
          final isSelected = answered == i;
          final isCorrect  = i == q.correctIndex && isSelected;
          final isWrong    = isSelected && !isCorrect;
          final color = isCorrect ? AppColors.green : isWrong ? AppColors.red : accent;

          return GestureDetector(
            onTap: () => _selectAnswer(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isSelected ? color.withOpacity(0.08) : AppColors.bgCard,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected ? color : AppColors.borderDefault,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 28, height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? color.withOpacity(0.15) : AppColors.bgPanel,
                      border: Border.all(color: isSelected ? color : AppColors.borderDefault),
                    ),
                    alignment: Alignment.center,
                    child: Text(['A','B','C','D'][i], style: AppText.mono(10, isSelected ? color : AppColors.textMuted, FontWeight.bold)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(e.value, style: AppText.body(13, AppColors.textPrimary))),
                  if (isCorrect) const Icon(Icons.check_circle_rounded, color: AppColors.green, size: 18),
                  if (isWrong)   const Icon(Icons.cancel_rounded,       color: AppColors.red,   size: 18),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _AQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  const _AQuestion({required this.question, required this.options, required this.correctIndex});
}

// =============================================================================
// SECTION: Mailbox Diagram — Asymmetric Key Visual
// =============================================================================

class _MailboxDiagram extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Column(
        children: [
          Text('THE PADLOCK MODEL', style: AppText.mono(9, AppColors.textMuted, FontWeight.bold)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _KeyCard('PUBLIC KEY 🔓', 'Anyone can\nencrypt with it', AppColors.cyan),
              const Icon(Icons.arrow_forward_rounded, color: AppColors.borderDefault, size: 18),
              _KeyCard('PRIVATE KEY 🔒', 'Only owner\ncan decrypt', AppColors.purple),
            ],
          ),
        ],
      ),
    );
  }
}

class _KeyCard extends StatelessWidget {
  final String title;
  final String desc;
  final Color  color;
  const _KeyCard(this.title, this.desc, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Column(
        children: [
          Text(title, style: AppText.mono(9, color, FontWeight.bold), textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Text(desc, style: AppText.body(10, AppColors.textMuted), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
