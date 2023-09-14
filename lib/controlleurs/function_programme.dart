import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
// import 'package:vp_chretien/models/donnees_sim.dart';
import 'package:vp_chretien/models/livre_model.dart';
import 'package:vp_chretien/models/programme_model.dart';

List<Map<String, dynamic>> elementsValides(List elements,bool valid){
  List<Map<String,dynamic>> lectures = [];
  for(var element in elements){
    if(element['valide']==valid){
      lectures.add(element);
    }
  }
  return lectures;
}

Future<List<LectureModel>> getProgrammes() async{
  String cycle="ancien";
  List<LectureModel> programmes=[];
  final ref = FirebaseDatabase.instance.ref().child("actifb");
  await ref.once().then((val) {
    Map value =val.snapshot.value as Map;
    cycle = value['actif'];
  });

  await FirebaseDatabase.instance.ref().child("lecturesParCycle/$cycle/lecture/04-07-2023/lectures").get()
      .then((value){
    // print(value.snapshot.children);
    for ( var val in value.children){
      LectureModel a=LectureModel.fromMap(val.value);
      programmes.add(a);
    }
    // print(programmes);
  })
  ;
  return programmes;
}

Future<List> getProgrammeDuJour(String date) async{
  List programmes=[];
  await FirebaseDatabase.instance.ref().child("lecturesParDate/$date/lectures").once()
      .then((value){
    // print(value.snapshot.children);
    for ( var val in value.snapshot.children){
      LectureModel a=LectureModel.fromMap(val.value);
      programmes.add(a);
    }
    // print(programmes);
  });
  return programmes;
}

void valideLecture(String lectureid , String? date , String idLivre) async{
  await FirebaseDatabase.instance.ref().child("lecturesParCycle/ancien/lecture/04-07-2023/lectures/$lectureid")
      .update({"etat" : "Oui"})
      .then((value){
    Fluttertoast.showToast(msg :"Lecture validée");
  })
      .catchError((e){
    Fluttertoast.showToast(msg :"Erreur de connection");
  });

  await FirebaseDatabase.instance.ref().child("lecturesParDate/$date/lectures/$lectureid")
      .update({"etat" : "Oui"})
      .then((value){
    Fluttertoast.showToast(msg :"Lecture validée");
  })
      .catchError((e){
    Fluttertoast.showToast(msg :"Erreur de connection");
  });

  await FirebaseDatabase.instance.ref().child("lecturesParLivre/$idLivre/lecture/$lectureid")
      .update({"etat" : "Oui"})
      .then((value){
    Fluttertoast.showToast(msg :"Lecture validée");
  })
      .catchError((e){
    Fluttertoast.showToast(msg :"Erreur de connection");
  });
}


// double progressionGeneraleSim(){
//   int valide=0 , nblectures=0;
//   for(var lecture in lectures){
//     nblectures++;
//     if(lecture.etat=='oui'){
//       valide++;
//     }
//   }
//   return (valide/nblectures)*100;
// }

List<LectureModel> etatLecture(List<LectureModel> maListe, String etat){
  List<LectureModel> listeEtat=[];
  for(var lecture in maListe){
    if(lecture.etat== etat && dateValide(lecture.disponible.toString())){
      listeEtat.add(lecture);
    }
  }
  return listeEtat;
}

bool dateValide(String dateIn){
  DateTime now = DateTime.now();
  DateFormat format = DateFormat('d-M-y');

  DateTime date = format.parse(dateIn);
  int compare = date.compareTo(now);
  bool status = compare > 0 ? false : true;
  return status;
}

Future<LivreModel> getLivre(String idlivre)async {

  final snapshot = await FirebaseDatabase.instance.ref().child("livres/$idlivre").get();
  // livre=LivreModel.fromMap(snapshot);


  return LivreModel.fromMap(snapshot.value);
}