import 'package:bible_seek/src/config/config.dart';
import 'package:bible_seek/src/api/authenticated_client.dart';
import 'package:bible_seek/src/design/spacing.dart';
import 'package:bible_seek/src/design/text_styles.dart';
import 'package:bible_seek/src/recent_topics_storage.dart';
import 'package:bible_seek/src/topic_verses_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

final _dio = AuthenticatedDio(Dio()).dio;

class Topic {
  final String label;
  final String id;

  Topic({required this.label, required this.id});
}

class SearchPage extends StatefulWidget {
  SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();

  var topics = <Topic>[];
  var _isLoading = true;
  var _recents = <({String id, String name})>[];

  @override
  void initState() {
    super.initState();
    fetchTopics();
    _loadRecents();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadRecents() async {
    final list = await RecentTopicsStorage.getRecents();
    if (mounted) setState(() => _recents = list);
  }

  Future<void> fetchTopics() async {
    setState(() => _isLoading = true);
    try {
      final response = await _dio.get(
        '${AppConfig.currentHost}/api/topics',
        options: Options(
          headers: <String, String>{'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            topics = (response.data as List)
                .map((topic) => Topic(
                      label: topic['name'],
                      id: topic['id'].toString(),
                    ))
                .toList();
            _isLoading = false;
          });
        }
      } else {
        throw Exception(
            'Failed to load topics: ${response.statusCode} ${response.statusMessage}');
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
      debugPrint('[SearchPage] Error: $e');
    }
  }

  /// Rank and sort topics matching the query.
  /// Score: exact=0, startsWith=1, contains=2.
  /// Sort: score asc, then name length asc, then alphabetical.
  List<Topic> _rankedResults(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return [];

    final matches = topics
        .where((t) => t.label.toLowerCase().contains(q))
        .map((t) {
          final labelNorm = t.label.trim().toLowerCase();
          int score;
          if (labelNorm == q) {
            score = 0;
          } else if (labelNorm.startsWith(q)) {
            score = 1;
          } else {
            score = 2;
          }
          return (topic: t, score: score);
        })
        .toList();

    matches.sort((a, b) {
      if (a.score != b.score) return a.score.compareTo(b.score);
      if (a.topic.label.length != b.topic.label.length) {
        return a.topic.label.length.compareTo(b.topic.label.length);
      }
      return a.topic.label.compareTo(b.topic.label);
    });

    return matches.map((m) => m.topic).toList();
  }

  void _onSearchSubmitted(String value) {
    final q = value.trim();
    if (q.isEmpty) return;

    Topic? exact;
    for (final t in topics) {
      if (t.label.trim().toLowerCase() == q.toLowerCase()) {
        exact = t;
        break;
      }
    }
    if (exact != null) {
      _onTopicTap(exact.id, exact.label);
      return;
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("No topic named '$q'"),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _onTopicTap(String id, String name) async {
    await RecentTopicsStorage.addRecent(id, name);
    if (mounted) _loadRecents();

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TopicVersesScreen(
          topicId: id,
          topicName: name,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final query = _controller.text.trim();
    final hasQuery = query.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Align(
          alignment: Alignment.centerLeft,
          child: TextField(
            controller: _controller,
            autofocus: true,
            textInputAction: TextInputAction.search,
            style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
            decoration: InputDecoration(
              hintText: 'Search for topics & keywords',
              hintStyle: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.5),
                fontWeight: FontWeight.normal,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 0,
              ),
              isDense: true,
              suffixIcon: hasQuery
                ? IconButton(
                    icon: Icon(
                      Icons.clear,
                      size: 20,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    onPressed: () {
                      _controller.clear();
                      setState(() {});
                    },
                  )
                : null,
            ),
            onChanged: (_) => setState(() {}),
            onSubmitted: _onSearchSubmitted,
          ),
        ),
      ),
      body: _buildBody(context, colorScheme, hasQuery, query),
    );
  }

  Widget _buildBody(
    BuildContext context,
    ColorScheme colorScheme,
    bool hasQuery,
    String query,
  ) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!hasQuery) {
      return _buildRecentsList(context, colorScheme);
    }

    final ranked = _rankedResults(query);
    if (ranked.isEmpty) {
      return _buildEmptyState(context, colorScheme);
    }

    return _buildSearchResults(context, colorScheme, ranked);
  }

  Widget _buildRecentsList(BuildContext context, ColorScheme colorScheme) {
    if (_recents.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.space24),
          child: Text(
            'Search for topics above.\nRecently opened topics will appear here.',
            textAlign: TextAlign.center,
            style: AppTextStyles.metaText(context).copyWith(
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ),
      );
    }

    final bottomPadding =
        MediaQuery.of(context).padding.bottom + AppSpacing.space8;
    return ListView(
      padding: EdgeInsets.only(
        top: AppSpacing.space8,
        bottom: bottomPadding,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.space16,
            vertical: AppSpacing.space8,
          ),
          child: Text(
            'Recent',
            style: AppTextStyles.sectionTitle(context),
          ),
        ),
        ..._recents.map(
          (r) => _TopicListTile(
            id: r.id,
            name: r.name,
            icon: Icons.history,
            colorScheme: colorScheme,
            onTap: () => _onTopicTap(r.id, r.name),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResults(
    BuildContext context,
    ColorScheme colorScheme,
    List<Topic> ranked,
  ) {
    final bottomPadding =
        MediaQuery.of(context).padding.bottom + AppSpacing.space8;
    return ListView(
      padding: EdgeInsets.only(
        top: AppSpacing.space8,
        bottom: bottomPadding,
      ),
      children: ranked
          .map(
            (t) => _TopicListTile(
              id: t.id,
              name: t.label,
              icon: Icons.search,
              colorScheme: colorScheme,
              onTap: () => _onTopicTap(t.id, t.label),
            ),
          )
          .toList(),
    );
  }

  Widget _buildEmptyState(BuildContext context, ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.space24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 48,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            ),
            const SizedBox(height: AppSpacing.space16),
            Text(
              'No topics found',
              style: AppTextStyles.sectionTitle(context),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.space8),
            Text(
              'Try a different search term.',
              style: AppTextStyles.metaText(context).copyWith(
                fontSize: 14,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.space24),
            OutlinedButton.icon(
              onPressed: () {
                // TODO: Request topic - wire when backend supports it
                debugPrint('[SearchPage] Request topic');
              },
              icon: const Icon(Icons.add_circle_outline, size: 18),
              label: const Text('Request topic'),
              style: OutlinedButton.styleFrom(
                foregroundColor: colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopicListTile extends StatelessWidget {
  const _TopicListTile({
    required this.id,
    required this.name,
    required this.icon,
    required this.colorScheme,
    required this.onTap,
  });

  final String id;
  final String name;
  final IconData icon;
  final ColorScheme colorScheme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: colorScheme.onSurfaceVariant,
        size: 22,
      ),
      title: Text(
        name,
        style: AppTextStyles.bodyLarge(context),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
        size: 22,
      ),
      onTap: onTap,
    );
  }
}

class SearchResults extends StatelessWidget {
  const SearchResults({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text('data');
  }
}

class SearchInput extends StatelessWidget {
  final TextEditingController textController;
  final String hintText;

  const SearchInput({
    required this.textController,
    required this.hintText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 0),
            blurRadius: 10,
            spreadRadius: 0,
            color: Colors.black.withValues(alpha: 0.15),
          ),
        ],
      ),
      child: TextField(
        controller: textController,
        onChanged: (_) {},
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.arrow_back),
          filled: true,
          fillColor: colorScheme.surface,
          hintText: hintText,
          hintStyle: TextStyle(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w300,
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
