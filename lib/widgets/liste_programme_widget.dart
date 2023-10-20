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
  Widget build(BuildContext context) {

    bool status = dateValide(widget.element.disponible.toString());

    // getAnneeActif();
    lectureValid();
    // print(isValid);

    return Container(
      height: 70.0,
      decoration: const BoxDecoration(
        border: BorderDirectional(
          top: BorderSide(
            color: _mainColor,
            width: 3.0,
          ),
        ),
      ),
      child: ListTile(
        leading: const FaIcon(FontAwesomeIcons.bookBible , size: 20.0, color: Colors.purple,),
        title: Text(
          widget.element.intitule.toString() ,
          style: const TextStyle(
            color: _mainColor,
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text("Lecture du ${widget.element.disponible}",
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 12.0,
            fontWeight: FontWeight.w400,
          ),
        ),
        trailing: !status ? const FaIcon(FontAwesomeIcons.lock , size: 20.0, color: Colors.red,) : const FaIcon(FontAwesomeIcons.unlock , size: 20.0, color: Colors.green,),
        onTap:widget.element.texte==null? null : (){
          if(widget.element.livrename=="quiz"){
            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
              return QuizPage(nomQuiz: widget.element.intitule,);
            }));
          }
          else {
            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
              return LecturePage(element: widget.element, disponible: status, isValid: isValid,);
            }));
          }
        },
      ),
    );
  }
}
