

import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:vp_chretien/services/auth_service.dart';

import '../models/programme_model.dart';

class ProgrammeService{

  final ref = FirebaseDatabase.instance.ref();

  //obtenir le cycle dans lequel nous sommes actuellement
  Future<String> getActifb() async{
    String cycle="";
    final snapshot= await ref.child("actifb/actif").get();
    cycle = snapshot.value.toString();
    return cycle;
  }
  String getActifb2() {
    String cycle="";
    ref.child("actifb/actif").once().then((val){
      cycle=val.snapshot.value as String;
    });
    return cycle;
  }
  //recupérer les lectures relatives à un jour donné
  List<LectureModel> get getProgrammeDuJour {
    String date=DateFormat("dd-MM-yyyy").format(DateTime.now());
    List<LectureModel> programmes=[];
    ref.child("lecturesParDate/$date/lectures").once()
        .then((value){
      for ( var val in value.snapshot.children){
        LectureModel a=LectureModel.fromMap(val.value);
        programmes.add(a);
      }
    });
    return programmes;
  }
  //obtenir la note du cycle de lecture
  String getNoteParCycle(String idAnnee,String cycle, String userId) {
    String noteParCycle="";
    // String idAnnee = anneeActif();
    final refParCycle = ref.child("lecturesParCycle/$cycle/$idAnnee/$userId");
    refParCycle.onValue.listen((event) {
      if(event.snapshot.value!=null) {
        Map valueCycle =event.snapshot.value as Map;
        noteParCycle = valueCycle['note'];
      }
    });
    return noteParCycle;
  }

  //avoir l'année active
  String anneeActif() {
    final refAnnee = ref.child('Parcours/AnneeActif');
    String an="";
    refAnnee.onValue.listen((event) {
      if(event.snapshot.value!=null){
        Map annee= event.snapshot.value as Map;
        an=annee['id'];
      }
    });
    return an;
  }

  //determiner la note par date
  String getNoteParDate(String cycle) {
    String date=DateFormat("dd-MM-yyyy").format(DateTime.now());
    String userId= AuthService().auth.currentUser!.uid;
    String note="";
    final refParDate = ref.child("lecturesParDate/$date/${anneeActif()}/${getActifb2()}/$userId/note");
    refParDate.once().then((value) {
      note=value.snapshot.value as String;
    });



    // Map? valueDate = snapshot.value!=null ? snapshot.value as Map : {};
    return note;
  }

  //obtenir l'ensemble des lectures d'un programme de lecture
  List<LectureModel> get getProgrammes{
    List<LectureModel> programmes=[];
    String cycle= getActifb() as String;
    ref.child("lecturesParCycle/$cycle/lecture").once()
        .then((event){
      // print(event.snapshot.children);
      for ( var val in event.snapshot.children){
        LectureModel a=LectureModel.fromMap(val.value);
        // print(a.uid);
        programmes.add(a);
      }

    });
    return programmes;

  }

  //avoir la liste des lecture à une date donnée
  List<LectureModel> lecturesADate(DateTime maDate) {
    List<LectureModel> programmes=[];

    String date = DateFormat("dd-MM-yyyy").format(maDate);

    ref.child("lecturesParDate/$date/lectures").once()
        .then((event){
      for ( var val in event.snapshot.children){
        LectureModel a=LectureModel.fromMap(val.value);
        programmes.add(a);
      }
    });
    return programmes;
  }
}