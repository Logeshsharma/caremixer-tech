import 'package:caremixer/ui/pokemon_list/providers/pokemon_list_provider.dart';
import 'package:caremixer/ui/pokemon_list/providers/ui_state_provider.dart';
import 'package:caremixer/ui/pokemon_list/utils/pokemon_utils.dart';
import 'package:caremixer/ui/pokemon_list/widgets/pokemon_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PokemonListScreen extends ConsumerStatefulWidget {
  const PokemonListScreen({super.key});

  @override
  ConsumerState<PokemonListScreen> createState() => _PokemonListScreenState();
}

class _PokemonListScreenState extends ConsumerState<PokemonListScreen> {
  late final TextEditingController _searchController;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;
    final currentScroll = position.pixels;
    final maxScroll = position.maxScrollExtent;

    _updateScrollToTopButton(currentScroll);
    _triggerPaginationIfNeeded(maxScroll - currentScroll);
  }

  void _updateScrollToTopButton(double currentScroll) {
    const threshold = 300.0;
    final uiState = ref.read(pokemonListUIProvider);
    final shouldShow = currentScroll > threshold;

    if (shouldShow != uiState.showScrollToTop) {
      ref.read(pokemonListUIProvider.notifier).setShowScrollToTop(shouldShow);
    }
  }

  void _triggerPaginationIfNeeded(double distanceFromBottom) {
    const threshold = 500.0;
    if (distanceFromBottom > threshold) return;

    final state = ref.read(pokemonListProvider);
    if (state.isLoading || state.isLoadingMore || !state.hasMore || state.error != null) {
      return;
    }

    ref.read(pokemonListProvider.notifier).loadMore();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pokemonListProvider);
    final uiState = ref.watch(pokemonListUIProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            _SearchHeader(
              searchController: _searchController,
              searchQuery: uiState.searchQuery,
            ),
            Expanded(
              child: _PokemonListContent(
                scrollController: _scrollController,
                state: state,
                searchQuery: uiState.searchQuery,
                onPokemonTap: _onPokemonTap,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: uiState.showScrollToTop
          ? _ScrollToTopButton(onPressed: _scrollToTop)
          : null,
    );
  }

  void _onPokemonTap(pokemon) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Clicked on ${PokemonUtils.capitalize(pokemon.name)}'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

// Header 
class _SearchHeader extends ConsumerWidget {
  final TextEditingController searchController;
  final String searchQuery;

  const _SearchHeader({
    required this.searchController,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pokemon',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 16),
          _SearchBar(
            controller: searchController,
            searchQuery: searchQuery,
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends ConsumerWidget {
  final TextEditingController controller;
  final String searchQuery;

  const _SearchBar({
    required this.controller,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: controller,
        onChanged: (value) {
          ref.read(pokemonListUIProvider.notifier).setSearchQuery(value);
        },
        decoration: InputDecoration(
          hintText: 'Search Pokemon...',
          hintStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 15,
          ),
          border: InputBorder.none,
          icon: Icon(
            Icons.search,
            color: Colors.grey.shade400,
            size: 22,
          ),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Colors.grey.shade400,
                    size: 20,
                  ),
                  onPressed: () {
                    controller.clear();
                    ref.read(pokemonListUIProvider.notifier).clearSearch();
                  },
                )
              : null,
        ),
      ),
    );
  }
}

// Content 
class _PokemonListContent extends ConsumerWidget {
  final ScrollController scrollController;
  final PokemonListState state;
  final String searchQuery;
  final Function(dynamic) onPokemonTap;

  const _PokemonListContent({
    required this.scrollController,
    required this.state,
    required this.searchQuery,
    required this.onPokemonTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredPokemons = _getFilteredPokemons();

    if (state.isLoading && state.pokemons.isEmpty) {
      return const _LoadingIndicator();
    }

    if (state.error != null && state.pokemons.isEmpty) {
      return _ErrorState(error: state.error!);
    }

    if (filteredPokemons.isEmpty) {
      return const _EmptyState();
    }

    return RefreshIndicator(
      color: Colors.black,
      strokeWidth: 2,
      onRefresh: () async {
        await ref.read(pokemonListProvider.notifier).refresh();
      },
      child: ListView.builder(
        controller: scrollController,
        padding: const EdgeInsets.all(20),
        physics: const ClampingScrollPhysics(),
        addAutomaticKeepAlives: true,
        addRepaintBoundaries: true,
        cacheExtent: 500,
        itemCount: filteredPokemons.length + (state.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == filteredPokemons.length) {
            return const _LoadingIndicator(padding: EdgeInsets.all(20));
          }

          return PokemonListCard(
            key: ValueKey('pokemon_${filteredPokemons[index].name}'),
            pokemon: filteredPokemons[index],
            onTap: () => onPokemonTap(filteredPokemons[index]),
          );
        },
      ),
    );
  }

  List _getFilteredPokemons() {
    if (searchQuery.isEmpty) return state.pokemons;

    return state.pokemons.where((pokemon) {
      final pokemonId = PokemonUtils.getPokemonId(pokemon.url);
      return pokemon.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          pokemonId.toString().contains(searchQuery);
    }).toList();
  }
}

// UI States
class _LoadingIndicator extends StatelessWidget {
  final EdgeInsets padding;

  const _LoadingIndicator({this.padding = EdgeInsets.zero});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.black,
        ),
      ),
    );
  }
}

class _ErrorState extends ConsumerWidget {
  final String error;

  const _ErrorState({required this.error});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            error,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              ref.read(pokemonListProvider.notifier).refresh();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade400,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'No Pokemon found',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ScrollToTopButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _ScrollToTopButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: Colors.black,
      child: const Icon(
        Icons.arrow_upward,
        color: Colors.white,
      ),
    );
  }
}
