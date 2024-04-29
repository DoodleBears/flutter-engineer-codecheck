import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_engineer_codecheck/state/github_search_page/github_search_result_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_engineer_codecheck/pages/github_search_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_engineer_codecheck/api/github_api.dart';

class MockGitHubApi extends Mock implements GitHubApi {
  @override
  Future<Map<String, dynamic>> searchRepositories(String query, int page,
      {int perPage = 10}) async {
    final file = File('test_resources/github_search_result.json');
    String jsonString = await file.readAsString();
    final json = jsonDecode(jsonString);
    return json;
  }
}

void main() {
  late String jsonString;
  late Map<String, dynamic> json;
  final mockGitHubApi = MockGitHubApi();

  setUpAll(() async {
    final file = File('test_resources/github_search_result.json');
    jsonString = await file.readAsString();
    json = jsonDecode(jsonString);
    print(json['total_count']);
  });

  Widget createTestWidget(Widget child, ProviderContainer container) {
    return UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        home: child,
        localizationsDelegates: const [
          S.delegate, // Your localization delegate
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''), // Assuming 'en' is one of your supported locales
        ],
      ),
    );
  }

  group('SearchPage Integration Tests', () {
    testWidgets('Initial state should have an empty list',
        (WidgetTester tester) async {
      final container = ProviderContainer();
      await tester.pumpWidget(createTestWidget(const SearchPage(), container));

      // Initially, check if the list is empty or a placeholder is shown
      // Check if the ListView is present but has no children
      final ListView listView = tester.widget(find.byType(ListView));
      final SliverChildDelegate delegate = listView.childrenDelegate;
      expect(delegate.estimatedChildCount, 0);
    });
  });
}
