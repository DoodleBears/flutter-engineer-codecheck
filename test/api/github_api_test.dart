import 'package:flutter_engineer_codecheck/api/github_api.dart';
import 'package:flutter_engineer_codecheck/models/github_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late GitHubApi gitHubApi;

  setUp(() {
    gitHubApi = GitHubApi();
  });
  group("GitHubApi - ", () {
    group("searchRepositories", () {
      test('statues code is 200', () async {
        // Arrange
        // Act
        final response =
            await gitHubApi.searchRepositories('flutter', 1, perPage: 10);

        final repositories = GitHubRepository.fromJson(response);
        // assert
        expect(repositories.items.length, 10);

        return null;
      });

      test('throws exception when query is empty', () async {
        // Arrange
        // Act & Assert
        final response = gitHubApi.searchRepositories('', 1);
        // assert
        expect(response, throwsA(isA<Exception>()));
      });
    });
  });
}
