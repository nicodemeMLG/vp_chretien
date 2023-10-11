import 'package:flutter/material.dart';

import '../widgets/liste_quiz_widget.dart';


const Color _mainColor= Color(0xFF446600);
class RapportQuiz extends StatelessWidget {
  final List quiz;
  final String idAnnee;
  const RapportQuiz({super.key, required this.quiz, required this.idAnnee});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
        "Rapport de Quiz",
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 20.0,
          color: _mainColor,
        ),
      ),
      ),
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text("Cliquez sur un quiz pour voir votre moyenne" , style: TextStyle(fontSize: 18.0),),
          ),
          Flexible(child: ListView(
            children: quiz.map((e){
              return ListeQuizWidget(element: e,idAnnee:idAnnee);
            }).toList(),
          ),),
        ],
      ),
    );
  }
}
