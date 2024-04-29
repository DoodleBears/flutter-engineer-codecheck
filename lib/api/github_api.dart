import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

var logger = Logger();

class GitHubApi {
  final String baseUrl = 'https://api.github.com/search/repositories';
  final http.Client client; // Add a client property

  // Modify the constructor to accept an http.Client
  GitHubApi({http.Client? client}) : client = client ?? http.Client();

  Future<Map<String, dynamic>> searchRepositories(String query, int page,
      {int perPage = 10}) async {
    final response = await client.get(
      Uri.parse('$baseUrl?q=$query&page=$page&per_page=$perPage'),
      headers: {
        'Accept': 'application/vnd.github.v3+json',
      },
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body) as Map<String, dynamic>;

      return body;
    } else {
      logger.e(response.statusCode.toString() + response.body);
      throw Exception('Failed to load repositories');
    }
  }
}
