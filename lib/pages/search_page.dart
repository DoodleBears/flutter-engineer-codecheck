import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_engineer_codecheck/state/github_search_expansion_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_engineer_codecheck/state/github_search_notifier.dart';
import 'package:logger/logger.dart';

var logger = Logger();

final searchBarVisibleProvider = StateProvider<bool>((ref) => true);

class SearchPage extends ConsumerWidget {
  const SearchPage({super.key});

  void search(WidgetRef ref) {
    String queryString = ref.read(githubSearchProvider.notifier).currentQuery;
    if (queryString.isNotEmpty) {
      ref.read(githubSearchProvider.notifier).searchRepositories(queryString);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = ScrollController();
    final expansionNotifier = ref.watch(itemExpansionProvider.notifier);

    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        ref.read(githubSearchProvider.notifier).searchRepositories(
            ref.read(githubSearchProvider.notifier).currentQuery,
            isLoadMore: true);
      }

      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
      
        if (ref.read(searchBarVisibleProvider)) {
          ref.read(searchBarVisibleProvider.notifier).state = false;
        }
      } else if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!ref.read(searchBarVisibleProvider)) {
          ref.read(searchBarVisibleProvider.notifier).state = true;
        }
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('GitHub Repository Search')),
      body: Stack(
        children: [
          // MARK: Repositories List
          Consumer(
            builder: (context, ref, _) {
              final state = ref.watch(githubSearchProvider);
              final expandedItems = ref.watch(itemExpansionProvider);

              if (state is AsyncLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              return state.when(
                data: (repositories) => ListView.builder(
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 8.0, bottom: 200.0),
                  controller: scrollController,
                  itemCount: repositories.length,
                  itemBuilder: (context, index) {
                    final repo = repositories[index];
                    return GestureDetector(
                      onTap: () {
                        expansionNotifier.toggleExpansion(index);
                      },
                      child: Card(
                        elevation: 1.0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 12.0),
                          child: expandedItems[index]
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              repo.owner!.avatarUrl),
                                        ),
                                        const SizedBox(width: 10.0),
                                        Column(
                                          children: [
                                            Text(repo.fullName),
                                            Text(
                                                'Language: ${repo.language ?? "Unknown"}'),
                                          ],
                                        )
                                      ],
                                    ),
                                    Text('Stars: ${repo.stargazersCount}'),
                                    Text('Watchers: ${repo.watchersCount}'),
                                    Text('Forks: ${repo.forksCount}'),
                                    Text(
                                        'Open issues: ${repo.openIssuesCount}'),
                                  ],
                                )
                              : Text(repo.fullName),
                        ),
                      ),
                    );
                  },
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('Error: $error')),
              );
            },
          ),
          // MARK: Search Bar
          AnimatedPositioned(
            bottom: ref.watch(searchBarVisibleProvider) ? 18.0 : -200.0,
            left: 10.0,
            right: 10.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          ref.read(githubSearchProvider.notifier).currentQuery =
                              value;
                        },
                        onSubmitted: (_) => search(ref),
                        decoration: const InputDecoration(
                          labelText: 'Search GitHub Repositories',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () => search(ref),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
