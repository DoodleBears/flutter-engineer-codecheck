import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

var logger = Logger();

class GitHubApi {
  final String baseUrl = 'https://api.github.com/search/repositories';

  Future<Map<String, dynamic>> searchRepositories(String query, int page,
      {int perPage = 20}) async {
    final response = await http.get(
      Uri.parse('$baseUrl?q=$query&page=$page&per_page=$perPage'),
      headers: {
        'Accept': 'application/vnd.github.v3+json',
      },
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body) as Map<String,
          dynamic>; // Ensure the decoded body is treated as a Map<String, dynamic>

      final List items = body['items'] as List; // Cast items explicitly

      final bool incompleteResults = body['incomplete_results']
          as bool; // Cast incompleteResults explicitly

      logger.i(items.length);
      logger.i(incompleteResults);
      logger.i(items);

      return body;
    } else {
      throw Exception('Failed to load repositories');
    }
  }
}
