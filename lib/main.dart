import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'crypto_simulator/crypto_state.dart';
import 'crypto_simulator/crypto_ui.dart';

void main() {
  runApp(const CryptoSimApp());
}

class CryptoSimApp extends StatelessWidget {
  const CryptoSimApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CryptoState(),
      child: MaterialApp(
        title: 'Crypto & Network Security Simulator',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF0A0A0A),
          textTheme: GoogleFonts.robotoMonoTextTheme(
            ThemeData.dark().textTheme,
          ),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF00FF41),      // Neon green
            secondary: Color(0xFFFF6600),    // Bright orange
            surface: Color(0xFF1A1A1A),
            error: Color(0xFFFF3333),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF0D0D0D),
            elevation: 0,
          ),
        ),
        home: const CryptoSimulatorScreen(),
      ),
    );
  }
}
