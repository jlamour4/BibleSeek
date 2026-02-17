import 'package:bible_seek/src/topic_verses_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:bible_seek/src/config/config.dart';
import 'package:bible_seek/src/api/authenticated_client.dart';

final dio = AuthenticatedDio(Dio()).dio;

class Topic {
  final String label;
  final String id;

  Topic({required this.label, required this.id});
}

class SearchPage extends StatefulWidget {
  SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController editingController = TextEditingController();

  var topics = <Topic>[]; // List of topics from API
  var filteredTopics = <Topic>[]; // List of topics to display, can be filtered
  var _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTopics();
  }

  @override
  void dispose() {
    editingController.dispose();
    super.dispose();
  }

  Future<void> fetchTopics() async {
    setState(() => _isLoading = true);
    try {
      final response = await dio.get(
        '${AppConfig.currentHost}/api/topics',
        options: Options(
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          topics = (response.data as List)
              .map((topic) => Topic(label: topic['name'], id: topic['id'].toString()))
              .toList();
          filteredTopics = topics;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load topics: ${response.statusCode} ${response.statusMessage}');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      print(e);
    }
  }

  void filterSearchResults(String query) {
    setState(() {
      filteredTopics = topics
          .where((topic) =>
              topic.label.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextField(
          controller: editingController,
          autofocus: true,
          style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
          decoration: InputDecoration(
            hintText: "Search for topics & keywords",
            hintStyle: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.5),
              fontWeight: FontWeight.normal,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
            isDense: true,
          ),
          onChanged: (value) {
            if (value.isEmpty) {
              setState(() => filteredTopics = topics);
            } else {
              filterSearchResults(value);
            }
          },
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : filteredTopics.isEmpty
              ? Center(
                  child: Text(
                    'No topics found',
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: filteredTopics.length,
                  itemBuilder: (context, index) {
                    final topic = filteredTopics[index];
                    return ListTile(
                      leading: Icon(
                        Icons.search,
                        color: colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                      title: Text(
                        topic.label,
                        style: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TopicVersesScreen(
                              topicId: topic.id,
                              topicName: topic.label,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}

class SearchResults extends StatelessWidget {
  const SearchResults({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text("data");
  }
}

class SearchInput extends StatelessWidget {
  final TextEditingController textController;
  final String hintText;
  const SearchInput(
      {required this.textController, required this.hintText, super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            offset: const Offset(0, 0),
            blurRadius: 10,
            spreadRadius: 0,
            color: Colors.black.withValues(alpha: 0.15)),
      ]),
      child: TextField(
        controller: textController,
        onChanged: (value) {},
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.arrow_back,
            // color: Color(0xff4338CA),
          ),
          filled: true,
          fillColor: colorScheme.surface,
          hintText: hintText,
          hintStyle:
              const TextStyle(color: Colors.grey, fontWeight: FontWeight.w300),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
