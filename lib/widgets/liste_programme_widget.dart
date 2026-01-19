// ignore_for_file: deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vp_chretien/controlleurs/function_programme.dart';
import 'package:vp_chretien/pages/lecture_page.dart';
import 'package:vp_chretien/models/programme_model.dart';

import '../pages/quiz_page.dart';


const Color _mainColor= Color(0xFF446600);
class ListeProgrammeWidget extends StatefulWidget {


  final LectureModel element;
  const ListeProgrammeWidget({super.key,required this.element});

  @override
  State<ListeProgrammeWidget> createState() => _ListeProgrammeWidgetState();
}

class _ListeProgrammeWidgetState extends State<ListeProgrammeWidget> {
  bool isValid=false;

  void lectureValid() async{
    String anneeActif="";
    final ref = FirebaseDatabase.instance.ref();
    // final event = await ref.child('Parcours/AnneeActif/id').once();
    // anneeActif =event.snapshot.value as String;
    final snapshotAnneeActif = await ref.child('Parcours/AnneeActif/id').get();
    anneeActif = snapshotAnneeActif.value as String;
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final snapshot = await ref.child("Users/$userId/$anneeActif/${widget.element.uid}").get();
    if(snapshot.value!=null){
      isValid=true;
    }

  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    lectureValid();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    bool status = dateValide(widget.element.disponible.toString());

    // getAnneeActif();
    lectureValid();
    // print(isValid);
    final isNotSmallScreen = MediaQuery.of(context).size.width >300;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        border: Border(
          
          top: BorderSide(
            color: status ? Colors.green : _mainColor,
            width: 3.0,
          ),
          // left: BorderSide(color: Colors.grey.withOpacity(0.2)),
          // right: BorderSide(color: Colors.grey.withOpacity(0.2)),
          // bottom: BorderSide(color: Colors.grey.withOpacity(0.2)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.element.texte == null
              ? null
              : () {
                  if (widget.element.livrename == "quiz") {
                    // if(!context.mounted) return;
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return QuizPage(nomQuiz: widget.element.intitule);
                        },
                      ),
                    );
                  } else {
                    // if(!context.mounted) return;
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return LecturePage(
                            element: widget.element,
                            disponible: status,
                            isValid: isValid,
                          );
                        },
                      ),
                    );
                  }
                },
          borderRadius: BorderRadius.circular(10.0),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                // Icône
                FaIcon(
                  widget.element.livrename == "quiz"
                      ? FontAwesomeIcons.circleQuestion
                      : FontAwesomeIcons.bookBible,
                  size: 20.0,
                  color: widget.element.livrename == "quiz"
                      ? Colors.orange
                      : Colors.purple,
                ),

                const SizedBox(width: 12.0),

                // Contenu
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.element.intitule.toString(),
                        style: TextStyle(
                          color: widget.element.texte == null
                              ? Colors.grey[400]
                              : _mainColor,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        "Lecture du ${widget.element.disponible}",
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: isNotSmallScreen ? 12.0 : 9.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8.0),

                // Icône de statut avec badge
                Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: status
                            ? Colors.green.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: FaIcon(
                        status ? FontAwesomeIcons.unlock : FontAwesomeIcons.lock,
                        size: isNotSmallScreen ? 18.0 : 15.0,
                        color: status ? Colors.green : Colors.red,
                      ),
                    ),
                    if (!status)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 8.0,
                          height: 8.0,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
