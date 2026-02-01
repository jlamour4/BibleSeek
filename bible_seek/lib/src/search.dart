import 'dart:convert';

import 'package:bible_seek/src/topic.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bible_seek/src/config/config.dart';
import 'package:bible_seek/src/api/authenticated_client.dart';

final dio = AuthenticatedDio(Dio()).dio;

class Topic {
  final String label;
  final String id;

  Topic({required this.label, required this.id});
}

class SearchPage extends StatefulWidget {
  SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController editingController = TextEditingController();

  var topics = <Topic>[]; // List of topics from API
  var filteredTopics = <Topic>[]; // List of topics to display, can be filtered

  @override
  void initState() {
    super.initState();
    fetchTopics();
  }

  Future<void> fetchTopics() async {
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
        });
      } else {
        throw Exception('Failed to load topics: ${response.statusCode} ${response.statusMessage}');
      }
    } catch (e) {
      // Handle error
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                  onChanged: (value) {
                    if (value.isEmpty) {
                      setState(() {
                        filteredTopics = topics;
                      });
                    } else {
                      filterSearchResults(value);
                    }
                  },
                  controller: editingController,
                  decoration: InputDecoration(
                      hintText: "Search for topics & keywords",
                      hintStyle: TextStyle(
                          color: Colors.black26, fontWeight: FontWeight.normal),
                      prefixIcon: Icon(Icons.arrow_back))),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: filteredTopics.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TopicPage()),
                      )
                    },
                    title: Row(
                      children: [
                        Icon(Icons.search),
                        SizedBox(width: 10),
                        Text(
                          '${filteredTopics[index].label}',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
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
      {required this.textController, required this.hintText, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            offset: const Offset(0, 0),
            blurRadius: 10,
            spreadRadius: 0,
            color: Colors.black.withOpacity(.15)),
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
          fillColor: Colors.white,
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
