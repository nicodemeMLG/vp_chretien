// ignore_for_file: deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vp_chretien/models/programme_model.dart';
import 'package:vp_chretien/pages/my_home_page.dart';

import '../pages/lecture_page.dart';
import '../pages/quiz_page.dart';

class ListeProgrammeJourWidget extends StatefulWidget {
  final LectureModel element;
  final String anneeActif;
  const ListeProgrammeJourWidget({super.key, required this.element, required this.anneeActif});

  @override
  State<ListeProgrammeJourWidget> createState() => _ListeProgrammeJourWidgetState();
}

class _ListeProgrammeJourWidgetState extends State<ListeProgrammeJourWidget> {
  bool isValid=false;

  void lectureValid() async{
    final ref = FirebaseDatabase.instance.ref();
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final snapshot = await ref.child("Users/$userId/${widget.anneeActif}/${widget.element.uid}").get();
    if(snapshot.value!=null){
      isValid=true;
    }

  }

  //on doit ici savoir si la lecture du jour à été validé ou pas
  @override
  Widget build(BuildContext context) {

    lectureValid();

    final isNotSmallScreen = MediaQuery.of(context).size.width >300;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: isValid ? Colors.green.withOpacity(0.3) : Colors.grey.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (widget.element.livrename == "quiz") {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return QuizPage(nomQuiz: widget.element.intitule);
                  },
                ),
              );
            } else {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return LecturePage(
                      element: widget.element,
                      disponible: true,
                      isValid: isValid,
                    );
                  },
                ),
              );
            }
          },
          borderRadius: BorderRadius.circular(10.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
            child: Row(
              children: [
                // Icône
                FaIcon(
                  widget.element.livrename == "quiz"
                      ? FontAwesomeIcons.circleQuestion
                      : FontAwesomeIcons.bookBible,
                  size: 26.0,
                  color: widget.element.livrename == "quiz"
                      ? Colors.orange
                      : Colors.purple,
                ),
                
                const SizedBox(width: 12.0),
                
                // Titre
                Expanded(
                  child: Text(
                    widget.element.intitule.toString(),
                    style: TextStyle(
                      color: mainColor,
                      fontSize: isNotSmallScreen ? 15.0 : 12.0,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                
                const SizedBox(width: 8.0),
                
                // Icône de statut simple
                Icon(
                  isValid ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: isValid ? Colors.green : Colors.grey[400],
                  size: isNotSmallScreen ? 24.0 : 20.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
