import 'package:caremixer/routing/routes.dart';
import 'package:caremixer/ui/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  final Widget child;

  const HomeScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocation = GoRouterState.of(context).uri.toString();
    final selectedIndex = _getSelectedIndex(currentLocation);

    return Scaffold(
      body: child,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(Routes.chat);
        },
        backgroundColor: AppColors.fabBackground,
        elevation: 4,
        child: const Icon(
          Icons.chat_bubble_outline,
          color: Colors.white,
          size: 24,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: AppColors.border,
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) => _handleNavigationItemSelected(index, context),
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.selectedTab,
          unselectedItemColor: AppColors.unselectedTab,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.timeline_outlined),
              activeIcon: Icon(Icons.timeline),
              label: 'Timeline',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.catching_pokemon_outlined),
              activeIcon: Icon(Icons.catching_pokemon),
              label: 'Pokemon',
            ),
          ],
        ),
      ),
    );
  }

  int _getSelectedIndex(String location) {
    if (location.startsWith(Routes.timeline)) return 0;
    if (location.startsWith(Routes.pokemonList)) return 1;
    return 0;
  }

  void _handleNavigationItemSelected(int index, BuildContext context) {
    HapticFeedback.lightImpact();

    switch (index) {
      case 0:
        context.go(Routes.timeline);
        break;
      case 1:
        context.go(Routes.pokemonList);
        break;
      default:
        break;
    }
  }
}
