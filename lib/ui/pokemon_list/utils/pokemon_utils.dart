import 'package:flutter/material.dart';

// Got Help from ChatGPT for utils

/// Utility class for Pokemon-related helpers
class PokemonUtils {
  /// Extract Pokemon ID from URL
  /// Example: https://pokeapi.co/api/v2/pokemon/1/ -> 1
  static int getPokemonId(String url) {
    final uri = Uri.parse(url);
    final segments = uri.pathSegments;
    // The ID is usually the second-to-last segment
    if (segments.length >= 2) {
      final idString = segments[segments.length - 2];
      return int.tryParse(idString) ?? 0;
    }
    return 0;
  }

  /// Get Pokemon image URL from ID
  static String getPokemonImageUrl(int id) {
    return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
  }

  /// Get Pokemon image URL from Pokemon URL
  static String getPokemonImageFromUrl(String url) {
    final id = getPokemonId(url);
    return getPokemonImageUrl(id);
  }

  /// Capitalize first letter of string
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  /// Format Pokemon ID with leading zeros
  static String formatPokemonId(int id) {
    return '#${id.toString().padLeft(3, '0')}';
  }

  /// Get color based on Pokemon ID (simulating type colors)
  /// In a real app, you'd fetch the actual type from the API
  static Color getPokemonColor(int id) {
    // Create a pseudo-random but consistent color based on ID
    final colorIndex = id % _pokemonColors.length;
    return _pokemonColors[colorIndex];
  }

  /// Pokemon type-inspired colors
  static const List<Color> _pokemonColors = [
    Color(0xFFA8E6CF), // Grass/Green
    Color(0xFFFFD3B6), // Fire/Orange
    Color(0xFFAAD9FF), // Water/Blue
    Color(0xFFFFF9AA), // Electric/Yellow
    Color(0xFFFFB3BA), // Fairy/Pink
    Color(0xFFD4A5A5), // Ground/Brown
    Color(0xFFB5EAD7), // Bug/Light Green
    Color(0xFFC7CEEA), // Psychic/Purple
    Color(0xFFE2E2E2), // Normal/Gray
    Color(0xFFFFDAB9), // Fighting/Peach
  ];

  /// Get a lighter shade of the color for card background
  static Color getLightColor(Color color) {
    return color.withValues(alpha: 0.5);
  }

  /// Get type icon based on Pokemon ID (simplified)
  static IconData getTypeIcon(int id) {
    final iconIndex = id % _typeIcons.length;
    return _typeIcons[iconIndex];
  }

  static const List<IconData> _typeIcons = [
    Icons.eco, // Grass
    Icons.local_fire_department, // Fire
    Icons.water_drop, // Water
    Icons.flash_on, // Electric
    Icons.favorite, // Fairy
    Icons.terrain, // Ground
    Icons.bug_report, // Bug
    Icons.psychology, // Psychic
    Icons.circle, // Normal
    Icons.sports_martial_arts, // Fighting
  ];
}

