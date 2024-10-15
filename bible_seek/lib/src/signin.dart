import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SigninPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Text("BibleSeek",
              style: GoogleFonts.kameron(
                  fontSize: 32, height: 1.25, color: Colors.black)),
        ],
      ),
    );
  }
}
