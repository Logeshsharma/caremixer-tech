import 'package:caremixer/ui/core/themes/theme.dart';
import 'package:caremixer/ui/pokemon_list/widgets/pokemon_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      home: const PokemonListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
