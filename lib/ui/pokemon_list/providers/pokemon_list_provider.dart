import 'package:caremixer/data/config/network_providers.dart';
import 'package:caremixer/data/models/pokemon_response.dart';
import 'package:caremixer/data/repositories/pokemon_repository.dart';
import 'package:caremixer/domain/models/pokemon_domian.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../utils/result.dart';

class PokemonListState {
  final List<Pokemon> pokemons;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final String? nextSet;
  final bool hasMore;

  const PokemonListState({
    this.pokemons = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.nextSet,
    this.hasMore = true,
  });

  PokemonListState copyWith({
    List<Pokemon>? pokemons,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    String? nextSet,
    bool? hasMore,
  }) {
    return PokemonListState(
      pokemons: pokemons ?? this.pokemons,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
      nextSet: nextSet ?? this.nextSet,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class PokemonListNotifier extends StateNotifier<PokemonListState> {
  PokemonListNotifier(this._repository) : super(const PokemonListState()) {
    loadInitial();
  }

  final PokemonRepository _repository;

  Future<void> refresh() async {
    state = const PokemonListState();
    await loadInitial();
  }

  Future<void> loadInitial() async {
    if (state.isLoading) return; 

    state = state.copyWith(
      isLoading: true,
      error: null,
      pokemons: [], 
    );

    await _loadData('offset=0&limit=20');
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore || state.isLoading) return;

    if (state.nextSet == null || state.nextSet!.isEmpty) {
      state = state.copyWith(hasMore: false);
      return;
    }

    state = state.copyWith(isLoadingMore: true, error: null);
    await _loadData(state.nextSet!);
  }

  Future<void> _loadData(String nextSet) async {
    final result = await _repository.getPokemons(nextSet);

    switch (result) {
      case Ok<PokemonDomian>():
        final newPokemons = result.value.pokemon;
        final cursor = result.value.cursor;

        final hasMore = cursor.isNotEmpty && newPokemons.isNotEmpty;

        state = state.copyWith(
          pokemons: [...state.pokemons, ...newPokemons],
          isLoading: false,
          isLoadingMore: false,
          nextSet: cursor,
          hasMore: hasMore,
          error: null,
        );
        break;

      case Error<PokemonDomian>():
        final errorMessage = result.error.toString().replaceFirst(
          'Exception: ',
          '',
        );
        state = state.copyWith(
          isLoading: false,
          isLoadingMore: false,
          error: errorMessage,
        );
        break;
    }
  }
}

final pokemonListProvider =
    StateNotifierProvider<PokemonListNotifier, PokemonListState>((ref) {
  final repository = ref.watch(repositoryProvider);
  return PokemonListNotifier(repository);
});
