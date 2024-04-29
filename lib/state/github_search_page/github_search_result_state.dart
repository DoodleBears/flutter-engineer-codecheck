import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_engineer_codecheck/api/github.dart';
import 'package:flutter_engineer_codecheck/state/github_search_page/github_repository_expansion_state.dart';
import 'package:flutter_engineer_codecheck/models/github_repository.dart';

final githubSearchProvider =
    StateNotifierProvider<GitHubSearchNotifier, AsyncValue<List<Item>>>(
        (ref) => GitHubSearchNotifier(ref.read));

class GitHubSearchNotifier extends StateNotifier<AsyncValue<List<Item>>> {
  final T Function<T>(ProviderListenable<T>) _read;
  int _page = 1;
  String _currentQuery = '';
  bool hasMore = true;

  GitHubSearchNotifier(this._read) : super(const AsyncValue.data([]));

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
      final results = await _read(gitHubApiProvider)
          .searchRepositories(currentQuery, _page);

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

final gitHubApiProvider = Provider<GitHubApi>((ref) => GitHubApi());
