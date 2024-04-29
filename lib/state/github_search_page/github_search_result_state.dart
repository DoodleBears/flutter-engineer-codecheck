import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_engineer_codecheck/api/github_api.dart';
import 'package:flutter_engineer_codecheck/state/github_search_page/github_repository_expansion_state.dart';
import 'package:flutter_engineer_codecheck/models/github_repository.dart';

// Modify the provider to allow passing a custom GitHubApi instance
final githubApiProvider = Provider<GitHubApi>((ref) => GitHubApi());

final githubSearchProvider =
    StateNotifierProvider<GitHubSearchNotifier, AsyncValue<List<Item>>>(
        (ref) => GitHubSearchNotifier(ref.read, ref.watch(githubApiProvider)));

class GitHubSearchNotifier extends StateNotifier<AsyncValue<List<Item>>> {
  final T Function<T>(ProviderListenable<T>) _read;
  final GitHubApi _githubApi;
  int _page = 1;
  String _currentQuery = '';
  bool hasMore = true;

  GitHubSearchNotifier(this._read, this._githubApi)
      : super(const AsyncValue.data([]));

  int get page => _page;

  String get currentQuery => _currentQuery;
  set currentQuery(String value) {
    if (_currentQuery != value) {
      _currentQuery = value;
    }
  }

  Future<void> searchRepositories(String query,
      {bool isLoadMore = false}) async {
    if (!isLoadMore) {
      _page = 1;
      currentQuery = query;
      state = const AsyncValue.loading();
    } else {
      _page++;
    }

    try {
      final results = await _githubApi.searchRepositories(currentQuery, _page);

      final repositories = GitHubRepository.fromJson(results);
      hasMore = repositories.incompleteResults;

      if (isLoadMore) {
        state = state.whenData((list) => list..addAll(repositories.items));
        _read(itemExpansionProvider.notifier)
            .extendExpansions(repositories.items.length);
        // Extend the expanded items list
      } else {
        state = AsyncValue.data(repositories.items);
        _read(itemExpansionProvider.notifier)
            .initializeExpansions(repositories.items.length);
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
