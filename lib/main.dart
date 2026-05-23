import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/theme.dart';
import 'app/router.dart';
import 'game/game_state.dart';

// =============================================================================
// SECTION: App Entry Point
// =============================================================================

void main() {
  runApp(const CryptoAgentApp());
}

class CryptoAgentApp extends StatelessWidget {
  const CryptoAgentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameState(),
      child: Consumer<GameState>(
        builder: (context, gameState, _) {
          return MaterialApp(
            title: 'CryptoAgent',
            debugShowCheckedModeBanner: false,
            theme: buildAppTheme(),
            // Route to onboarding if no agent yet, else the map
            initialRoute: gameState.hasAgent ? '/map' : '/onboard',
            onGenerateRoute: generateRoute,
          );
        },
      ),
    );
  }
}
