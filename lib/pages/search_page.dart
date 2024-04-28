import 'package:flutter/material.dart';
import 'package:flutter_engineer_codecheck/state/github_search_expansion_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_engineer_codecheck/state/github_search_notifier.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class SearchPage extends ConsumerWidget {
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
    });

    return Scaffold(
      appBar: AppBar(title: const Text('GitHub Repository Search')),
      body: Consumer(
        builder: (context, ref, _) {
          final state = ref.watch(githubSearchProvider);
          final expandedItems = ref.watch(itemExpansionProvider);

          if (state is AsyncLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return state.when(
            data: (repositories) => ListView.builder(
              controller: scrollController,
              itemCount: repositories.length,
              itemBuilder: (context, index) {
                final repo = repositories[index];
                return GestureDetector(
                  onTap: () {
                    logger.d("touch $index");
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
                                      backgroundImage:
                                          NetworkImage(repo.owner!.avatarUrl),
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
                                Text('Open issues: ${repo.openIssuesCount}'),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                    decoration: const InputDecoration(
                      labelText: 'Search GitHub Repositories',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    ),
                  ),
                ),
                const SizedBox(width: 10.0),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    String queryString =
                        ref.read(githubSearchProvider.notifier).currentQuery;
                    logger.d(queryString);
                    if (queryString.isNotEmpty) {
                      // Navigator.pop(context);
                      ref
                          .read(githubSearchProvider.notifier)
                          .searchRepositories(queryString);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
