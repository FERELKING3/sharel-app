import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharel_app/core/theme.dart';
import 'package:sharel_app/providers/app_state.dart';
import 'package:sharel_app/screens/home/home_page.dart';
import 'package:sharel_app/screens/discovery/discovery_page.dart';
import 'package:sharel_app/screens/me/me_page.dart';
import 'package:sharel_app/l10n/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: Builder(builder: (context) {
        return MaterialApp(
          title: 'SHAREL',
          theme: appTheme(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          localeResolutionCallback: (locale, supported) {
            // Respect system locale; default supported locale is fr
            if (locale == null) return supported.first;
            for (var s in supported) {
              if (s.languageCode == locale.languageCode) return s;
            }
            return supported.first;
          },
          home: const AppShell(),
        );
      }),
    );
  }
}

class AppShell extends StatelessWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = const [HomePage(), DiscoveryPage(), MePage()];
    final labels = [
      AppLocalizations.of(context)!.labelSend,
      AppLocalizations.of(context)!.labelReceive,
      'Moi'
    ];
    return LayoutBuilder(builder: (context, constraints) {
      final isWide = constraints.maxWidth >= 800;
      return Scaffold(
        body: Row(children: [
          if (isWide)
            NavigationRail(
              selectedIndex: context.watch<AppState>().selectedIndex,
              onDestinationSelected: (i) => context.read<AppState>().setIndex(i),
              destinations: const [
                NavigationRailDestination(icon: Icon(Icons.home), label: Text('Accueil')),
                NavigationRailDestination(icon: Icon(Icons.public), label: Text('Découvrir')),
                NavigationRailDestination(icon: Icon(Icons.person), label: Text('Moi')),
              ],
            ),
          Expanded(child: pages[context.watch<AppState>().selectedIndex]),
        ]),
        bottomNavigationBar: isWide
            ? null
            : BottomNavigationBar(
                currentIndex: context.watch<AppState>().selectedIndex,
                onTap: (i) => context.read<AppState>().setIndex(i),
                items: [
                  BottomNavigationBarItem(icon: const Icon(Icons.home), label: labels[0]),
                  BottomNavigationBarItem(icon: const Icon(Icons.public), label: labels[1]),
                  BottomNavigationBarItem(icon: const Icon(Icons.person), label: labels[2]),
                ],
              ),
      );
    });
  }
}

