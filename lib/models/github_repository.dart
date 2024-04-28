import 'package:json_annotation/json_annotation.dart';

part 'github_repository.g.dart';

@JsonSerializable()
class GitHubRepository {
  final String name;
  final String owner;
  final String language;
  final int stars;
  final int watchers;
  final int forks;
  final int issues;

  GitHubRepository({
    required this.name,
    required this.owner,
    required this.language,
    required this.stars,
    required this.watchers,
    required this.forks,
    required this.issues,
  });

  factory GitHubRepository.fromJson(Map<String, dynamic> json) =>
      _$GitHubRepositoryFromJson(json);
  Map<String, dynamic> toJson() => _$GitHubRepositoryToJson(this);
}
