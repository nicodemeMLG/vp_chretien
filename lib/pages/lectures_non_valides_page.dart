import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../controlleurs/function_programme.dart';
import '../models/programme_model.dart';
import '../widgets/liste_programme_widget.dart';

const Color _mainColor= Color(0xFF446600);
class LecturesNonValidesPage extends StatelessWidget {
  final String? anneeActif;
  const LecturesNonValidesPage({super.key, this.anneeActif});

  @override
  Widget build(BuildContext context) {

    String userId= FirebaseAuth.instance.currentUser!.uid;
    String cycle="";
    
    Future<List<LectureModel>> getLecturesNonValide() async{
      List<String> lectureVldId=[];
      List<LectureModel> lectureNonVld=[];
      final ref= FirebaseDatabase.instance.ref();
      final snapshot1 = await ref.child("Users/$userId/$anneeActif").get();
      LectureModel lecture = LectureModel();
      for(var l in snapshot1.children){
        lecture = LectureModel.fromMap(l.value as Map);

        lectureVldId.add(lecture.uid.toString());
      }

      
      //recuperation du cycle
      final snapshot2 = await ref.child("actifb/actif").get();
      cycle=snapshot2.value as String;

      final snapshot3 = await ref.child("lecturesParCycle/$cycle/lecture").get();
      for(var l in snapshot3.children){
        
        lecture = LectureModel.fromMap(l.value as Map);
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
        appBar: AppBar(title: const Text(
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
              List<LectureModel> lecturesNonVld=snapshot.data as List<LectureModel>;
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
