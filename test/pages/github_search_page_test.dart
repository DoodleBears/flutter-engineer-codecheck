import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_engineer_codecheck/api/github_api.dart';
import 'package:flutter_engineer_codecheck/models/github_repository.dart';
import 'package:flutter_engineer_codecheck/state/github_search_page/github_search_result_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_engineer_codecheck/pages/github_search_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'github_search_page_test.mocks.dart';

@GenerateMocks([Client])
void main() {
  late MockClient client;
  late GitHubApi gitHubApi;
  const String baseUrl = 'https://api.github.com/search/repositories';
  const header = {'Accept': 'application/vnd.github.v3+json'};

  setUp(() {
    client = MockClient();
    gitHubApi = GitHubApi(client: client);
  });

  group('Unit Test', () {
    test('githubApiProvider should provide a GitHubApi instance', () {
      final container = ProviderContainer();
      final githubApi = container.read(githubApiProvider);
      expect(githubApi, isA<GitHubApi>());
    });
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

    testWidgets('After submitting search, there should be 3 Cards in UI',
        (WidgetTester tester) async {
      // Arrange
      const query = 'flutter';
      const page = 1;
      const perPage = 10;
      const url = '$baseUrl?q=$query&page=$page&per_page=$perPage';

      final File file = File('test_resource/github_search_result.json');
      final jsonString = file.readAsStringSync(encoding: utf8);
      final json = jsonDecode(jsonString) as Map<String, dynamic>;

      when(
        client.get(
          Uri.parse(url),
          headers: header,
        ),
      ).thenAnswer((_) async => Response(
            utf8.decode(utf8.encode(jsonEncode(json))),
            200,
          ));

      final container = ProviderContainer(
        overrides: [
          githubApiProvider.overrideWith((ref) => gitHubApi),
        ],
      );

      await tester.pumpWidget(createTestWidget(const SearchPage(), container));

      await tester.enterText(find.byType(TextField), query);
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // assert
      verify(client.get(
        Uri.parse(url),
        headers: header,
      )).called(1);
      // NOTE: JSON only contains 2 items, so 2 items + 1 search bar, is 3 Card
      expect(find.byType(Card), findsNWidgets(3));
    });
  });
}
