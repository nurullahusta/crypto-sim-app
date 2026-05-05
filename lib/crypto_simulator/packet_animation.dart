import 'package:flutter/material.dart';
import 'crypto_state.dart';

// ─────────────────────────────────────────────────────────────
// FILE 3 OF 3 — ANIMATION LAYER
// Owner : Animations Developer
// ─────────────────────────────────────────────────────────────

/// Animated data‑packet that moves across Alice → Hacker → Bob.
///
/// Accepts the current [SimulationPhase] and display text via the
/// parent widget, so it remains a *stateless consumer* of the state
/// layer. All tween / curve logic lives here.
class PacketAnimationWidget extends StatefulWidget {
  final SimulationPhase phase;
  final String displayText;
  final bool isEncrypted;

  const PacketAnimationWidget({
    super.key,
    required this.phase,
    required this.displayText,
    required this.isEncrypted,
  });

  @override
  State<PacketAnimationWidget> createState() => _PacketAnimationWidgetState();
}

class _PacketAnimationWidgetState extends State<PacketAnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController _posController;
  late Animation<double> _posAnimation;

  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  // 0.0 = Alice (left), 0.5 = Hacker (center), 1.0 = Bob (right)
  double _targetPos = 0.0;

  @override
  void initState() {
    super.initState();

    _posController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _posAnimation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _posController, curve: Curves.easeInOutCubic),
    );

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _glowAnimation =
        Tween<double>(begin: 0.3, end: 1.0).animate(_glowController);
  }

  @override
  void didUpdateWidget(covariant PacketAnimationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.phase != widget.phase) {
      _onPhaseChanged(widget.phase);
    }
  }

  void _onPhaseChanged(SimulationPhase phase) {
    double newTarget;
    switch (phase) {
      case SimulationPhase.idle:
        newTarget = 0.0;
        break;
      case SimulationPhase.aliceEncrypting:
        newTarget = 0.0;
        break;
      case SimulationPhase.transitToHacker:
        newTarget = 0.5;
        break;
      case SimulationPhase.hackerInspecting:
        newTarget = 0.5;
        break;
      case SimulationPhase.transitToBob:
        newTarget = 1.0;
        break;
      case SimulationPhase.bobDecrypting:
        newTarget = 1.0;
        break;
      case SimulationPhase.completed:
        newTarget = 1.0;
        break;
    }

    if (newTarget != _targetPos) {
      _posAnimation = Tween<double>(begin: _targetPos, end: newTarget).animate(
        CurvedAnimation(parent: _posController, curve: Curves.easeInOutCubic),
      );
      _targetPos = newTarget;
      _posController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _posController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool visible = widget.phase != SimulationPhase.idle;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: visible ? 1.0 : 0.0,
      child: SocAnimatedBuilder(
        listenable: Listenable.merge([_posAnimation, _glowAnimation]),
        builder: (context, child) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final totalWidth = constraints.maxWidth;
              // Packet width is fixed; position is fraction of travel lane.
              const packetWidth = 110.0;
              final travelWidth = totalWidth - packetWidth;
              final leftOffset = _posAnimation.value * travelWidth;

              return SizedBox(
                height: 60,
                child: Stack(
                  children: [
                    // ── Animated wire ──
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _WirePainter(
                          progress: _posAnimation.value,
                          color: widget.isEncrypted
                              ? const Color(0xFF00FF41)
                              : const Color(0xFFFF6600),
                        ),
                      ),
                    ),
                    // ── Data packet ──
                    Positioned(
                      left: leftOffset,
                      top: 4,
                      child: _buildPacket(),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildPacket() {
    final accentColor =
        widget.isEncrypted ? const Color(0xFF00FF41) : const Color(0xFFFF6600);
    final glowOpacity = _glowAnimation.value;

    return Container(
      width: 110,
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        border: Border.all(color: accentColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.4 * glowOpacity),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: Row(
        children: [
          Icon(
            widget.isEncrypted ? Icons.lock : Icons.lock_open,
            color: accentColor,
            size: 18,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              widget.displayText.length > 8
                  ? '${widget.displayText.substring(0, 8)}…'
                  : widget.displayText,
              style: TextStyle(
                fontFamily: 'RobotoMono',
                fontSize: 10,
                color: accentColor,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
              ),
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Animated wire / path painter ──────────────────────────
class _WirePainter extends CustomPainter {
  final double progress;
  final Color color;

  _WirePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final basePaint = Paint()
      ..color = color.withOpacity(0.15)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Full wire
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      basePaint,
    );

    // Active portion
    final activePaint = Paint()
      ..color = color.withOpacity(0.7)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width * progress, size.height / 2),
      activePaint,
    );

    // Draw node dots at 0%, 50%, 100%
    final dotPaint = Paint()..color = color.withOpacity(0.6);
    for (final frac in [0.0, 0.5, 1.0]) {
      canvas.drawCircle(
        Offset(frac * size.width, size.height / 2),
        4,
        dotPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _WirePainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}

// ── Animated builder (thin wrapper so we can merge listenables) ─
class SocAnimatedBuilder extends AnimatedWidget {
  final Widget Function(BuildContext context, Widget? child) builder;

  const SocAnimatedBuilder({
    super.key,
    required super.listenable,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) => builder(context, null);
}

// ── Scanline / static noise overlay for SOC terminal feel ──
class ScanlineOverlay extends StatefulWidget {
  final Widget child;
  const ScanlineOverlay({super.key, required this.child});

  @override
  State<ScanlineOverlay> createState() => _ScanlineOverlayState();
}

class _ScanlineOverlayState extends State<ScanlineOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        // Subtle animated scanline
        SocAnimatedBuilder(
          listenable: _ctrl,
          builder: (context, _) {
            return Positioned(
              top: _ctrl.value *
                  (MediaQuery.of(context).size.height + 4) -
                  2,
              left: 0,
              right: 0,
              child: Container(
                height: 2,
                color: const Color(0xFF00FF41).withOpacity(0.06),
              ),
            );
          },
        ),
      ],
    );
  }
}

/// Blinking cursor widget for terminal feel.
class BlinkingCursor extends StatefulWidget {
  const BlinkingCursor({super.key});

  @override
  State<BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<BlinkingCursor>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SocAnimatedBuilder(
      listenable: _ctrl,
      builder: (context, _) {
        return Opacity(
          opacity: _ctrl.value,
          child: const Text(
            '█',
            style: TextStyle(
              color: Color(0xFF00FF41),
              fontSize: 14,
              fontFamily: 'RobotoMono',
            ),
          ),
        );
      },
    );
  }
}
