import 'package:flutter/material.dart';

class NoteQuiz extends StatelessWidget {
  final String note;
  const NoteQuiz({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text("Vous avez obtenu la note de: $note%"),
      ),
    );
  }
}
