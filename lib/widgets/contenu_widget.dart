import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vp_chretien/models/livre_model.dart';
import '../models/programme_model.dart';
import '../models/user_model.dart';

class ContenuWidget extends StatefulWidget {
  final LectureModel element;
  final bool isValid;
  const ContenuWidget({super.key , required this.element, required this.isValid});

  @override
  State<ContenuWidget> createState() => _ContenuWidgetState();
}

class _ContenuWidgetState extends State<ContenuWidget> {
  LivreModel livre=LivreModel();
  String? idAnnee;
  final String? userId=FirebaseAuth.instance.currentUser?.uid;
  int nbrlectures=0;
  final ref = FirebaseDatabase.instance.ref();
  void getNbrLecturesParDate() async{
    final snapshot = await ref.child("lecturesParDate/${widget.element.disponible}/lectures").get();
    nbrlectures= snapshot.children.length;
    //setState(() {});
  }
  UserModel user=UserModel();
  void getUser() async{
    DatabaseReference refUser = FirebaseDatabase.instance.ref().child('Admin/Users/$userId');
    final snapshot1 = await refUser.get();
    user= UserModel.fromMap(snapshot1.value as Map);
  }

  @override
  Widget build(BuildContext context) {

    int countCycle;

    if(widget.element.cycle.toString() == "ancien"){
      countCycle=912;
    } else if(widget.element.cycle.toString() == "nouveau"){
      countCycle=415;
    } else {
      countCycle=912;
    }
    void leLivre() async{
      final snapshot = await ref.child('livres/${widget.element.livreuid}').get();
      livre = LivreModel.fromMap(snapshot.value);

    }

    void anneeActif() async{
      final snapshot = await ref.child('Parcours/AnneeActif').get();
      Map annee=snapshot.value as Map;
      idAnnee = annee['id'];
      // print(snapshot.value);
    }

    anneeActif();
    leLivre();
    getNbrLecturesParDate();
    getUser();

    // print("Nombre chapitres: "+livre.nbrechapitre.toString());
    // print("annee actif : "+idAnnee);
    final isNotSmallScreen = MediaQuery.of(context).size.width >300;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: isNotSmallScreen?20.0:15.0,),
        Row(
          children: [
            Text("Lecture du ", style: TextStyle(color: Colors.grey.shade600 , fontSize: isNotSmallScreen?18.0:13.0, fontWeight: FontWeight.w500),),
            Text(widget.element.disponible.toString(), style: TextStyle(color: Colors.blue , fontSize: isNotSmallScreen?16.0:11.0, fontWeight: FontWeight.w500))
          ],
        ),
        const SizedBox(height: 20.0,),
        Text(widget.element.intitule.toString(), style: TextStyle(color: Colors.grey.shade600 , fontSize:isNotSmallScreen?18.0:13.0, fontWeight: FontWeight.w500),),
        const SizedBox(height: 10.0,),
        /*asPicture ? Image(
          image: NetworkImage(widget.element.productImageUrl.toString()),
        ) : const SizedBox(),*/
        const SizedBox(height: 10.0,),
        Text(widget.element.texte.toString(), style: TextStyle(color: Colors.grey.shade600 , fontSize: isNotSmallScreen?16.0:11.0, fontWeight: FontWeight.w500),),
        const SizedBox(height: 10.0,),

        ElevatedButton(
          onPressed: widget.isValid ? null : (){
            enregistrementNoteParDate(idAnnee!, userId!, widget.element.cycle, nbrlectures,widget.element.disponible , user);
            enregistrementNoteParCycle(idAnnee!,userId!,widget.element.cycle,countCycle,user);
            enregistrementNoteParLivre(idAnnee!,userId!,widget.element.livreuid,user);
            enregistrerLectureValider(idAnnee!,userId! , widget.element.uid,widget.element);

            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[700],
            fixedSize: const Size(double.maxFinite, 35),
            padding: EdgeInsets.zero,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(0)),
            ),
          ),
          child: Text(
            widget.isValid ? "Déjà validé": "Valider" ,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colors.white,
                fontSize: isNotSmallScreen?16.0:11.0,
                fontWeight: FontWeight.w600
            ),
          ),

        ),
      ],
    );
  }
}

void enregistrementNoteParDate(String idAnnee, String idUser,String? cycle,int? nbrLectures,String? date, UserModel user) async{
  double note = 1*100/nbrLectures!;
  final ref = FirebaseDatabase.instance.ref().child("lecturesParDate/$date/$idAnnee/$cycle/$idUser");
  final snapshot = await ref.get();
  Map noteLecture={};
  if(snapshot.value==null){
    noteLecture ={
      'name': user.name,
      'note': note.toStringAsFixed(2),
      'uid':idUser,
    };

  }else{
    noteLecture = snapshot.value as Map;
    noteLecture["note"] = (double.parse(noteLecture["note"]) + note).toStringAsFixed(2);
  }

  await ref.set(noteLecture);
}

void enregistrementNoteParCycle(String idAnnee, String idUser,String? cycle,int nbrLectures,UserModel user) async{
  double note = 1*100/nbrLectures;
  final ref = FirebaseDatabase.instance.ref().child("lecturesParCycle/$cycle/$idAnnee/$idUser");
  final snapshot = await ref.get();
  // Map noteLecture = snapshot.value as Map;
  // noteLecture["note"] = (double.parse(noteLecture["note"]) + note).toStringAsFixed(2);
  Map noteLecture={};
  if(snapshot.value==null){

    noteLecture ={
      'name': user.name,
      'note': note.toStringAsFixed(2),
      'uid':idUser,
    };

  }else{

    noteLecture = snapshot.value as Map;
    noteLecture["note"] = (double.parse(noteLecture["note"]) + note).toStringAsFixed(2);

  }
  await ref.set(noteLecture);
}

void enregistrementNoteParLivre(String idAnnee, String idUser,String? idLivre,UserModel user) async{
  final refCount =  FirebaseDatabase.instance.ref().child("lecturesParLivre/$idLivre/lectures");
  final snapshotCount = await refCount.get();
  int count = snapshotCount.children.length;
  double note = 1*100/count;
  final ref = FirebaseDatabase.instance.ref().child("lecturesParLivre/$idLivre/$idAnnee/$idUser");
  final snapshot = await ref.get();
  // Map noteLecture = snapshot.value as Map;
  // noteLecture["note"] = (double.parse(noteLecture["note"]) + note).toStringAsFixed(2);
  Map noteLecture={};
  if(snapshot.value==null){
    noteLecture ={
      'name': user.name,
      'note': note.toStringAsFixed(2),
      'uid':idUser,
    };

  }else{
    noteLecture = snapshot.value as Map;
    noteLecture["note"] = (double.parse(noteLecture["note"]) + note).toStringAsFixed(2);
  }
  await ref.set(noteLecture);
}

void enregistrerLectureValider(String idAnnee, String idUser,String? idLecture,LectureModel? lecture) async{
  Map<String,dynamic> lectureVld = {
    "disponible":lecture?.disponible,
    "etat":lecture?.etat,
    "intitule":lecture?.intitule,
    "uid":lecture?.uid,
  };
  final ref = FirebaseDatabase.instance.ref().child("Users/$idUser/$idAnnee/$idLecture");
  await ref.set(lectureVld).then((value) { Fluttertoast.showToast(msg: "Validé !");});
}