import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// JSONPlaceholder provides sample posts without requiring an API key.
/// These are demonstration community posts, not live financial news.
class MarketPost {
  final int id;
  final String title;
  final String body;

  const MarketPost({
    required this.id,
    required this.title,
    required this.body,
  });

  factory MarketPost.fromJson(Map<String, dynamic> json) {
    return MarketPost(
      id: json['id'] as int,
      title: json['title'] as String? ?? 'Untitled post',
      body: json['body'] as String? ?? '',
    );
  }
}

class MarketNewsScreen extends StatefulWidget {
  const MarketNewsScreen({super.key});

  @override
  State<MarketNewsScreen> createState() => _MarketNewsScreenState();
}

class _MarketNewsScreenState extends State<MarketNewsScreen> {
  List<MarketPost> _posts = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final response = await http
          .get(Uri.parse('https://jsonplaceholder.typicode.com/posts'))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        throw Exception('The server returned an unexpected response.');
      }

      final decoded = jsonDecode(response.body);
      if (decoded is! List) {
        throw const FormatException('The server response was not a list.');
      }

      final posts = decoded
          .map((item) => MarketPost.fromJson(item as Map<String, dynamic>))
          .toList();

      if (!mounted) return;
      setState(() {
        _posts = posts;
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage =
            'We couldn’t load market community posts. Check your internet connection and try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Market Community Feed',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.amber.shade50,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: const Text(
              'Demo API content from JSONPlaceholder — these are sample posts, not live financial news or trading advice.',
              style: TextStyle(fontSize: 12),
            ),
          ),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildContent() {
    // All four states are inside a scrollable so pull-to-refresh works.
    if (_isLoading) {
      return RefreshIndicator(
        onRefresh: _loadPosts,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 220),
            Center(child: CircularProgressIndicator()),
            SizedBox(height: 16),
            Center(child: Text('Loading community posts...')),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return RefreshIndicator(
        onRefresh: _loadPosts,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 100),
            const Icon(Icons.cloud_off, size: 64, color: Colors.blueGrey),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Unable to load posts',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            Text(_errorMessage!, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            Center(
              child: FilledButton.icon(
                onPressed: _loadPosts,
                icon: const Icon(Icons.refresh),
                label: const Text('Try again'),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      );
    }

    if (_posts.isEmpty) {
      return RefreshIndicator(
        onRefresh: _loadPosts,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 150),
            Icon(Icons.inbox_outlined, size: 64, color: Colors.blueGrey),
            SizedBox(height: 16),
            Center(
              child: Text(
                'No posts available yet.',
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 150),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadPosts,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(12),
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          final post = _posts[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: CircleAvatar(child: Text('${post.id}')),
              title: Text(
                post.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(post.body),
              ),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }
}
