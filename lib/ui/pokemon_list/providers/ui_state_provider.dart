import 'package:flutter_riverpod/flutter_riverpod.dart';

class PokemonListUIState {
  final String searchQuery;
  final bool showScrollToTop;

  const PokemonListUIState({
    this.searchQuery = '',
    this.showScrollToTop = false,
  });

  PokemonListUIState copyWith({
    String? searchQuery,
    bool? showScrollToTop,
  }) {
    return PokemonListUIState(
      searchQuery: searchQuery ?? this.searchQuery,
      showScrollToTop: showScrollToTop ?? this.showScrollToTop,
    );
  }
}

class PokemonListUINotifier extends StateNotifier<PokemonListUIState> {
  PokemonListUINotifier() : super(const PokemonListUIState());

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setShowScrollToTop(bool show) {
    state = state.copyWith(showScrollToTop: show);
  }

  void clearSearch() {
    state = state.copyWith(searchQuery: '');
  }
}

final pokemonListUIProvider =
    StateNotifierProvider<PokemonListUINotifier, PokemonListUIState>((ref) {
  return PokemonListUINotifier();
});

