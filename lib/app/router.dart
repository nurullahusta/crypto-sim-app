import 'package:flutter/material.dart';

import '../screens/onboarding_screen.dart';
import '../screens/mission_map_screen.dart';
import '../screens/mission_screen.dart';

// =============================================================================
// SECTION: Route Definitions
// =============================================================================

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/onboard':
      return _fade(const OnboardingScreen());
    case '/map':
      return _fade(const MissionMapScreen());
    case '/mission':
      return _slide(const MissionScreen());
    default:
      return _fade(const OnboardingScreen());
  }
}

PageRoute<T> _fade<T>(Widget page) => PageRouteBuilder<T>(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, anim, __, child) =>
          FadeTransition(opacity: anim, child: child),
      transitionDuration: const Duration(milliseconds: 250),
    );

PageRoute<T> _slide<T>(Widget page) => PageRouteBuilder<T>(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, anim, __, child) {
        final c = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(0.06, 0), end: Offset.zero).animate(c),
          child: FadeTransition(opacity: c, child: child),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
