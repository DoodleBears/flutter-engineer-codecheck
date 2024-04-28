import 'package:json_annotation/json_annotation.dart';

part 'github_repository.g.dart';

@JsonSerializable()
class GitHubRepository {
  @JsonKey(name: 'total_count')
  int totalCount;
  @JsonKey(name: 'incomplete_results')
  bool incompleteResults;
  @JsonKey(name: 'items')
  List<Item> items;

  GitHubRepository({
    required this.totalCount,
    required this.incompleteResults,
    required this.items,
  });

  factory GitHubRepository.fromJson(Map<String, dynamic> json) =>
      _$GitHubRepositoryFromJson(json);
  Map<String, dynamic> toJson() => _$GitHubRepositoryToJson(this);
}

@JsonSerializable()
class Item {
  @JsonKey(name: 'name')
  String name;
  @JsonKey(name: 'full_name')
  String fullName;
  @JsonKey(name: 'owner')
  Owner? owner;
  @JsonKey(name: 'description')
  String? description;
  @JsonKey(name: 'fork')
  bool fork;
  @JsonKey(name: 'url')
  String url;
  @JsonKey(name: 'created_at')
  DateTime createdAt;
  @JsonKey(name: 'updated_at')
  DateTime updatedAt;
  @JsonKey(name: 'language')
  String? language;
  @JsonKey(name: 'score')
  int score;

  Item({
    required this.name,
    required this.fullName,
    required this.owner,
    required this.description,
    required this.fork,
    required this.url,
    required this.createdAt,
    required this.updatedAt,
    required this.language,
    required this.score,
  });

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
  Map<String, dynamic> toJson() => _$ItemToJson(this);
}

@JsonSerializable()
class Owner {
  @JsonKey(name: 'login')
  String login;
  @JsonKey(name: 'avatar_url')
  String avatarUrl;
  @JsonKey(name: 'url')
  String url;
  @JsonKey(name: 'type')
  String type;

  Owner({
    required this.login,
    required this.avatarUrl,
    required this.url,
    required this.type,
  });

  factory Owner.fromJson(Map<String, dynamic> json) => _$OwnerFromJson(json);
  Map<String, dynamic> toJson() => _$OwnerToJson(this);
}
