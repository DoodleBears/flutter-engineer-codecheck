// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'github_repository.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GitHubRepository _$GitHubRepositoryFromJson(Map<String, dynamic> json) =>
    GitHubRepository(
      name: json['name'] as String,
      owner: json['owner'] as String,
      language: json['language'] as String,
      stars: (json['stars'] as num).toInt(),
      watchers: (json['watchers'] as num).toInt(),
      forks: (json['forks'] as num).toInt(),
      issues: (json['issues'] as num).toInt(),
    );

Map<String, dynamic> _$GitHubRepositoryToJson(GitHubRepository instance) =>
    <String, dynamic>{
      'name': instance.name,
      'owner': instance.owner,
      'language': instance.language,
      'stars': instance.stars,
      'watchers': instance.watchers,
      'forks': instance.forks,
      'issues': instance.issues,
    };
