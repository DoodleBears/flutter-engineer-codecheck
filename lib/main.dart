import 'package:flutter/material.dart';
import 'package:flutter_engineer_codecheck/l10n/l10n.dart';
import 'package:flutter_engineer_codecheck/pages/github_search_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: L10n.all,
      theme: ThemeData(
        cardTheme: const CardTheme(
          color: Colors.white,
          elevation: 0.0,
          surfaceTintColor: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          scrolledUnderElevation: BorderSide.strokeAlignCenter,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black,
          background: Colors.grey[200],
        ),
        useMaterial3: true,
      ),
      home: const SearchPage(),
    );
  }
}
