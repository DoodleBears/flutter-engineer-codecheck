import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_engineer_codecheck/state/github_search_page/github_repository_expansion_state.dart';
import 'package:flutter_engineer_codecheck/state/github_search_page/search_bar_visible_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_engineer_codecheck/state/github_search_page/github_search_result_state.dart';
import 'package:logger/logger.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

var logger = Logger();

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
    final expandedItems = ref.watch(itemExpansionProvider);

    scrollController.addListener(() {
      // MARK: Infinity Scroll
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        ref.read(githubSearchProvider.notifier).searchRepositories(
            ref.read(githubSearchProvider.notifier).currentQuery,
            isLoadMore: true);
      }

      // MARK: Auto show/hide search bar
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
      appBar: AppBar(
        title: Text(S.of(context).githubSearchPageAppBarTitle),
      ),
      body: Stack(
        children: [
          // MARK: Repositories List
          Consumer(
            builder: (context, ref, _) {
              final searchResultState = ref.watch(githubSearchProvider);

              if (searchResultState is AsyncLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              return searchResultState.when(
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
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 12.0),
                          child: expandedItems[index]
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              repo.owner!.avatarUrl),
                                        ),
                                        const SizedBox(width: 10.0),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                repo.fullName,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                              Text(
                                                  '${S.of(context).githubSearchPageRepoLanguage}: ${repo.language ?? S.of(context).githubSearchPageRepoLanguageUnknown}'),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Text(
                                        '${S.of(context).githubSearchPageRepoStars}: ${repo.stargazersCount}'),
                                    Text(
                                        '${S.of(context).githubSearchPageRepoWatchers}: ${repo.watchersCount}'),
                                    Text(
                                        '${S.of(context).githubSearchPageRepoForks}: ${repo.forksCount}'),
                                    Text(
                                        '${S.of(context).githubSearchPageRepoOpenIssues}: ${repo.openIssuesCount}'),
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
              elevation: 4.0,
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
                        decoration: InputDecoration(
                          labelText:
                              S.of(context).githubSearchPageTextFieldHint,
                          labelStyle: const TextStyle(
                            fontSize: 14.0,
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 10,
                            ),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          fillColor: Colors.grey[200],
                          filled: true,
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
