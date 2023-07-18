import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../controlleurs/function_programme.dart';
import '../models/donnees_sim.dart';
import '../models/programme_model.dart';
import '../widgets/liste_programme_widget.dart';

final Color _mainColor= Color(0xFF446600);
class LecturesNonValidesPage extends StatelessWidget {
  final String? anneeActif;
  const LecturesNonValidesPage({super.key, this.anneeActif});

  @override
  Widget build(BuildContext context) {

    List elements = [
      {
        "titre": "Adoration 1 ",
        "date": "17-06-2023",
        "contenu" : "",
        "valide":true,
      },
      {
        "titre": "Adoration Août" ,
        "date": "17-01-2023",
        "contenu" : "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
        ,"valide":true,
      },
      {
        "titre": "Adoration Septembre",
        "date": "14-09-2023",
        "contenu" : "",
        "valide":false,
      },
      {
        "titre": "Adoration 1 ",
        "date": "08-12-2023",
        "contenu" : "",
        "valide":false,
      },
      {
        "titre": "Adoration Août" ,
        "date": "17-01-2023",
        "contenu" : "",
        "valide":true,
      },
      {
        "titre": "Adoration Septembre",
        "date": "14-09-2023",
        "contenu" : "",
        "valide":false,
      },
    ];
    String userId= FirebaseAuth.instance.currentUser!.uid;
    String cycle="";
    
    Future<List<ProgrammeModel>> getLecturesNonValide() async{
      List<String> lectureVldId=[];
      List<ProgrammeModel> lectureNonVld=[];
      final ref= FirebaseDatabase.instance.ref();
      final snapshot1 = await ref.child("Users/$userId/$anneeActif").get();
      ProgrammeModel lecture = ProgrammeModel();
      for(var l in snapshot1.children){
        lecture = ProgrammeModel.fromMap(l.value as Map);

        lectureVldId.add(lecture.uid.toString());
      }

      
      //recuperation du cycle
      final snapshot2 = await ref.child("actifb/actif").get();
      cycle=snapshot2.value as String;

      final snapshot3 = await ref.child("lecturesParCycle/$cycle/lecture").get();
      for(var l in snapshot3.children){
        
        lecture = ProgrammeModel.fromMap(l.value as Map);
        // print(lecture.uid);
        if(!(lectureVldId.contains(lecture.uid.toString())) && dateValide(lecture.disponible.toString()) ){

          lectureNonVld.add(lecture);
        }
        
      }
      return lectureNonVld;
    }



    // // List<Map<String, dynamic>> lecturesValidees = elementsValides(elements , false);
    // List<ProgrammeModel> lecturesNonVld = etatLecture(lectures,"non");
    // print(lecturesNonVld);

    return Scaffold(
        appBar: AppBar(title: Text(
          "Mes Lectures non validées",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20.0,
            color: _mainColor,
          ),
        ),),
        body: FutureBuilder(
          future: getLecturesNonValide(),
          builder: (context, snapshot){
            if(snapshot.connectionState==ConnectionState.waiting){
              return const Center(
                child: CircularProgressIndicator(color: Colors.green,),
              );
            }
            else if(snapshot.hasData){
              List<ProgrammeModel> lecturesNonVld=snapshot.data as List<ProgrammeModel>;
              // print(snapshot.data);
              return ListView(
                children: lecturesNonVld.map((e){
                  return ListeProgrammeWidget(element: e,);
                }).toList(),
              );
            }
            else{
              return const Center(
                child: Text("Erreur de connexion..."),
              );
            }
          },
        ),
    );
  }
}
