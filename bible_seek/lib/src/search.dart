import 'package:bible_seek/src/topic.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

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

  final duplicateItems = List<String>.generate(10000, (i) => "Item $i");
  var items = <String>[];

  final topics = [
    Topic(label: "777", id: "1"),
    Topic(label: "faith", id: "2"),
    Topic(label: "love", id: "3"),
    Topic(label: "grace", id: "4"),
    Topic(label: "peace", id: "5"),
    Topic(label: "kindness", id: "6"),
    Topic(label: "happiness", id: "7"),
    Topic(label: "Christ", id: "8"),
    Topic(label: "God", id: "9"),
    Topic(label: "Jesus", id: "10"),
    Topic(label: "religion", id: "11"),
    Topic(label: "condemnation", id: "12"),
  ];

  @override
  void initState() {
    items = duplicateItems;
    super.initState();
  }

  void filterSearchResults(String query) {
    setState(() {
      items = duplicateItems
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
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
                    filterSearchResults(value);
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
                itemCount: topics.length,
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
                          '${topics[index].label}',
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
