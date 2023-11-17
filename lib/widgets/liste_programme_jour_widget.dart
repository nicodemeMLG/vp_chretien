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
      height: 70.0,
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 5.0),
      padding: const EdgeInsets.all(7.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 2,
              offset: Offset(0,2),
            ),
          ]

      ),

      child: ListTile(

        leading: const FaIcon(FontAwesomeIcons.bookBible , size: 30.0, color: Colors.purple,),
        title: Text(
          widget.element.intitule.toString() ,
          style: TextStyle(
            color: mainColor,
            fontSize: isNotSmallScreen?18.0:13.0,
            fontWeight: FontWeight.w600,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        trailing: isValid ? Text("Validé", style: TextStyle(color: Colors.green, fontSize: isNotSmallScreen?16.0:11.0, fontWeight: FontWeight.w800),) : const Text("Non validé", style: TextStyle(color: Colors.red, fontSize: 16.0, fontWeight: FontWeight.w800),),

        onTap: (){
          if(widget.element.livrename=="quiz"){
            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
              return QuizPage(nomQuiz: widget.element.intitule,);
            }));
          }
          else {
            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
              return LecturePage(element: widget.element, disponible: true, isValid: isValid,);
            }));
          }
          // Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
          //   return LecturePage(element: widget.element, disponible: true,isValid:isValid);
          // }));
        },
      ),
    );
  }
}
