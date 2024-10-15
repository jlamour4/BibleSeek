import 'package:bible_seek/src/search.dart';
import 'package:bible_seek/src/signin.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'question.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            const Background(),
            SingleChildScrollView(
              child: Column(
                children: [
                  const IntroCard(),
                  const TrendingCard()
                  // SizedBox(
                  //   width: MediaQuery.of(context).size.width,
                  //   height: 335,
                  //   child: ListView.builder(
                  //       scrollDirection: Axis.horizontal,
                  //       itemCount: planetCards.length,
                  //       itemBuilder: (context, index) {
                  //         return PlanetCardWidget2(
                  //             planetCard: planetCards[index]);
                  //       }),
                  // ),
                  // InformationCard(
                  //   planetCard: PlanetCard(
                  //       image:
                  //           "https://firebasestorage.googleapis.com/v0/b/flutterbricks-public.appspot.com/o/Planets%2Fsolar.png?alt=media&token=50992182-d228-484a-b6a7-ffab59023027",
                  //       title: "Solar System"),
                  // ),
                  // InformationCard(
                  //   planetCard: PlanetCard(
                  //       image:
                  //           "https://firebasestorage.googleapis.com/v0/b/flutterbricks-public.appspot.com/o/Planets%2Fplanet3.png?alt=media&token=497fbf32-30c7-4ce5-ae0a-c387d517aa1a",
                  //       title: "Mercury"),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TrendingCard extends StatelessWidget {
  const TrendingCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 0, left: 0, right: 0),
      height: 290,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      padding: const EdgeInsets.fromLTRB(25.0, 20.0, 25.0, 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                IconData(0xe392, fontFamily: 'MaterialIcons'),
                color: const Color(0xFFFF9447),
              ),
              const SizedBox(width: 5.0),
              Text("Trending Topics",
                  style: TextStyle(
                      fontSize: 18,
                      height: 1.25,
                      fontFamily: "BigBottom",
                      fontWeight: FontWeight.normal)),
            ],
          ),
          const SizedBox(height: 10.0),
          // SearchInput(
          //   textController: TextEditingController(),
          //   hintText: "Search for topics and keywords",
          // ),
          TrendingTopicButton(),
          const SizedBox(height: 5.0),
          TrendingTopicButton(),
          const SizedBox(height: 5.0),
          TrendingTopicButton(),
          const SizedBox(height: 5.0),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Color(0xFFF1F1F1), // Text color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              elevation: 0, // Subtle shadow
              padding: const EdgeInsets.symmetric(horizontal: 16),
              minimumSize: const Size(double.infinity, 45), // Full-width button
            ),
            onPressed: () => print("Object 1"),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: const Text(
                    'View More',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        overflow: TextOverflow.ellipsis),
                  ),
                ),
                Icon(Icons.chevron_right)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TrendingTopicButton extends StatelessWidget {
  const TrendingTopicButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Color(0xFFF1F1F1), // Text color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        elevation: 0, // Subtle shadow
        padding: const EdgeInsets.symmetric(horizontal: 16),
        minimumSize: const Size(double.infinity, 45), // Full-width button
      ),
      onPressed: () => print("Object 1"),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: const Text(
              'Grace',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  overflow: TextOverflow.ellipsis),
            ),
          ),
          Text(
            '638 searches',
            style: TextStyle(
                color: const Color.fromARGB(150, 0, 0, 0),
                fontSize: 14,
                fontWeight: FontWeight.normal),
          ),
        ],
      ),
    );
  }
}

class Background extends StatelessWidget {
  const Background({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F1),
        // gradient: LinearGradient(
        //     colors: [Colors.blue[50]!, Colors.blueAccent, Colors.purple[300]!],
        //     begin: Alignment.topCenter,
        //     end: Alignment.bottomCenter),
      ),
    );
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
            offset: const Offset(0, 8),
            blurRadius: 10,
            spreadRadius: 0,
            // blurStyle: BlurStyle.solid,
            color: Colors.black.withOpacity(.15)),
      ]),
      child: TextField(
        controller: textController,
        onChanged: (value) {
          //Do something wi
        },
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.search,
            color: Color(0xff4338CA),
          ),
          filled: true,
          fillColor: Colors.blue[50],
          hintText: hintText,
          hintStyle:
              const TextStyle(color: Colors.grey, fontWeight: FontWeight.w300),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(50.0)),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(50.0)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2.0),
            borderRadius: BorderRadius.all(Radius.circular(50.0)),
          ),
        ),
      ),
    );
  }
}

class IntroCard extends StatelessWidget {
  const IntroCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 0, left: 0, right: 0),
      height: 275,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(50.0),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.indigo[800]!.withOpacity(.15),
          //     offset: const Offset(0, 10),
          //     blurRadius: 0,
          //     spreadRadius: 0,
          //   )
          // ],
          gradient: const RadialGradient(
        colors: [
          Color.fromRGBO(126, 154, 216, 0.773),
          Color.fromRGBO(122, 139, 176, 1)
        ],
        focal: Alignment.topCenter,
        radius: 2,
      )),
      padding: const EdgeInsets.all(25.0),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 15.0),
          Text("BibleSeek",
              style: GoogleFonts.kameron(
                  fontSize: 32, height: 1.25, color: Colors.white)),
          // TextStyle(
          //     color: Colors.white,
          //     fontSize: 32,
          //     height: 1.25,
          //     fontFamily: "BigBottom",
          //     fontWeight: FontWeight.bold)),
          const SizedBox(height: 15.0),
          // SearchInput(
          //   textController: TextEditingController(),
          //   hintText: "Search for topics and keywords",
          // ),
          SearchButton(),
          const SizedBox(height: 15.0),
          Text("What does the Bible",
              style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w300)),
          Text("say about _______ ?",
              style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w300)),
        ],
      ),
    );
  }
}

class SearchButton extends StatelessWidget {
  const SearchButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white, // Text color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(35),
        ),
        elevation: 2, // Subtle shadow
        padding: const EdgeInsets.symmetric(horizontal: 16),
        minimumSize: const Size(double.infinity, 54), // Full-width button
      ),
      onPressed: () => {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SearchPage()),
        )
      },
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: const Text(
              'Search for topics & keywords',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  overflow: TextOverflow.ellipsis),
            ),
          ),
          // const SizedBox(width: 20),
          IconButton(onPressed: () {}, icon: const Icon(Icons.mic)),
          GestureDetector(
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SigninPage()),
              )
            },
            child: CircleAvatar(
                backgroundColor: const Color.fromRGBO(165, 159, 140, 1),
                child: Icon(Icons.person)),
          )
        ],
      ),
    );
  }
}
