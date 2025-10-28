import 'package:caremixer/data/config/network_providers.dart';
import 'package:caremixer/data/models/pokemon_response.dart';
import 'package:caremixer/data/repositories/pokemon_repository.dart';
import 'package:caremixer/domain/models/pokemon_domian.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../utils/result.dart';

// List state
class PokemonListState {
  final List<Pokemon> pokemons;
  final bool isLoading;
  final String? error;
  final String? nextSet;

  const PokemonListState({
    this.pokemons = const [],
    this.isLoading = false,
    this.error,
    this.nextSet,
  });

  PokemonListState copyWith({
    List<Pokemon>? pokemons,
    bool? isLoading,
    String? error,
    String? nextSet,
  }) {
    return PokemonListState(
      pokemons: pokemons ?? this.pokemons,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      nextSet: nextSet ?? this.nextSet,
    );
  }
}

// List notifier
class PokemonListNotifier extends StateNotifier<PokemonListState> {
  PokemonListNotifier(this._repository) : super(const PokemonListState()) {
    loadlist();
  }

  final PokemonRepository _repository;

  void refresh() {
    loadlist();
  }

  void loadMore() {
    loadlist(nextSet: state.nextSet ?? 'offset=0&limit=10');
  }

  Future<void> loadlist({String nextSet = 'offset=0&limit=10'}) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _repository.getPokemons(nextSet);

    switch (result) {
      case Ok<PokemonDomian>():
        state = state.copyWith(
          pokemons: [...state.pokemons, ...result.value.pokemon],
          isLoading: false,
          nextSet: result.value.cursor,
          error: null,
        );

        break;
      case Error<PokemonDomian>():
        // Use the specific error message from the remote API
        final errorMessage = result.error.toString().replaceFirst(
              'Exception: ',
              '',
            );
        state = state.copyWith(isLoading: false, error: errorMessage);
        break;
    }
  }
}

// Provider
final pokemonListProvider =
    StateNotifierProvider<PokemonListNotifier, PokemonListState>((ref) {
  final repository = ref.watch(repositoryProvider);
  return PokemonListNotifier(repository);
});
