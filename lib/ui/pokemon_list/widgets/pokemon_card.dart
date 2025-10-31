import 'package:cached_network_image/cached_network_image.dart';
import 'package:caremixer/data/models/pokemon_response.dart';
import 'package:caremixer/ui/pokemon_list/utils/pokemon_utils.dart';
import 'package:flutter/material.dart';


class PokemonListCard extends StatelessWidget {
  final Pokemon pokemon;
  final VoidCallback? onTap;

  const PokemonListCard({
    super.key,
    required this.pokemon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final pokemonId = PokemonUtils.getPokemonId(pokemon.url);
    final pokemonColor = PokemonUtils.getPokemonColor(pokemonId);
    final imageUrl = PokemonUtils.getPokemonImageFromUrl(pokemon.url);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: _listCardDecoration,
        child: Row(
          children: [
            _ListCardImage(
              pokemonId: pokemonId,
              pokemonColor: pokemonColor,
              imageUrl: imageUrl,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _ListCardInfo(
                pokemonName: pokemon.name,
                pokemonId: pokemonId,
                pokemonColor: pokemonColor,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  static final _listCardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: const [
      BoxShadow(
        color: Color(0x19000000),
        blurRadius: 8,
        offset: Offset(0, 2),
      ),
    ],
  );
}




class _ListCardImage extends StatelessWidget {
  final int pokemonId;
  final Color pokemonColor;
  final String imageUrl;

  const _ListCardImage({
    required this.pokemonId,
    required this.pokemonColor,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: pokemonColor.withAlpha(50),
        borderRadius: BorderRadius.circular(12),
      ),
      child: _PokemonImage(
        pokemonId: pokemonId,
        imageUrl: imageUrl,
        pokemonColor: pokemonColor,
        size: 80,
      ),
    );
  }
}


class _PokemonImage extends StatelessWidget {
  final int pokemonId;
  final String imageUrl;
  final Color pokemonColor;
  final double size;

  const _PokemonImage({
    required this.pokemonId,
    required this.imageUrl,
    required this.pokemonColor,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'pokemon $pokemonId',
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        height: size,
        fit: BoxFit.contain,
        placeholder: (_, __) => Center(
          child: SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(pokemonColor),
            ),
          ),
        ),
        errorWidget: (_, __, ___) => Icon(
          Icons.catching_pokemon,
          size: size * 0.55,
          color: pokemonColor.withAlpha(128),
        ),
      ),
    );
  }
}

class _ListCardInfo extends StatelessWidget {
  final String pokemonName;
  final int pokemonId;
  final Color pokemonColor;

  const _ListCardInfo({
    required this.pokemonName,
    required this.pokemonId,
    required this.pokemonColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                PokemonUtils.capitalize(pokemonName),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            Text(
              PokemonUtils.formatPokemonId(pokemonId),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: pokemonColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _TypeBadge(
          pokemonId: pokemonId,
          pokemonColor: pokemonColor,
        ),
      ],
    );
  }
}

class _TypeBadge extends StatelessWidget {
  final int pokemonId;
  final Color pokemonColor;

  const _TypeBadge({
    required this.pokemonId,
    required this.pokemonColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: pokemonColor.withAlpha(50),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            PokemonUtils.getTypeIcon(pokemonId),
            size: 14,
            color: pokemonColor,
          ),
          const SizedBox(width: 4),
          Text(
            'Type ${(pokemonId % 10) + 1}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: pokemonColor,
            ),
          ),
        ],
      ),
    );
  }
}

