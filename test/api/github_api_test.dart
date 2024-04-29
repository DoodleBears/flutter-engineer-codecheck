import 'dart:convert';
import 'dart:io';

import 'package:flutter_engineer_codecheck/api/github_api.dart';
import 'package:flutter_engineer_codecheck/models/github_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'github_api_test.mocks.dart';

// class MockHttpClient extends Mock implements Client {}

@GenerateMocks([Client])
void main() {
  group("GitHubApi - ", () {
    group("searchRepositories", () {
      test('statues code is 200', () async {
        // Arrange
        const String baseUrl = 'https://api.github.com/search/repositories';
        const query = 'flutter';
        const page = 1;
        const perPage = 2;
        const url = '$baseUrl?q=$query&page=$page&per_page=$perPage';

        final client = MockClient();
        final gitHubApi = GitHubApi(client: client);

        final File file = File('test/api/github_search_result.json');
        final jsonString = file.readAsStringSync(encoding: utf8);
        final json = jsonDecode(jsonString) as Map<String, dynamic>;

        when(
          client.get(
            Uri.parse(url),
            headers: {
              'Accept': 'application/vnd.github.v3+json',
            },
          ),
        ).thenAnswer((_) async => Response(
              utf8.decode(utf8.encode(jsonEncode(json))),
              200,
            ));
        // Act
        final response =
            await gitHubApi.searchRepositories(query, page, perPage: perPage);

        verify(client.get(
          Uri.parse(url),
          headers: {
            'Accept': 'application/vnd.github.v3+json',
          },
        )).called(1);

        final repositories = GitHubRepository.fromJson(response);
        // assert
        expect(repositories.items.length, 2);
      });

      test('throws exception when query is empty', () async {
        // Arrange
        const String baseUrl = 'https://api.github.com/search/repositories';
        const query = '';
        const page = 1;
        const perPage = 2;
        const url = '$baseUrl?q=$query&page=$page&per_page=$perPage';

        final client = MockClient();
        final gitHubApi = GitHubApi(client: client);

        when(
          client.get(
            Uri.parse(url),
            headers: {
              'Accept': 'application/vnd.github.v3+json',
            },
          ),
        ).thenAnswer((_) async => Response(
              '{}',
              422,
            ));
        // Act

        expect(
            () async => await gitHubApi.searchRepositories(query, page,
                perPage: perPage),
            throwsA(isA<Exception>()));

        verify(client.get(
          Uri.parse(url),
          headers: {
            'Accept': 'application/vnd.github.v3+json',
          },
        )).called(1);
      });
    });
  });
}
