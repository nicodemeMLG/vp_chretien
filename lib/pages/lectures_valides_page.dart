import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../models/programme_model.dart';
import '../widgets/liste_programme_widget.dart';

const Color _mainColor= Color(0xFF446600);
class LecturesValidesPage extends StatefulWidget {

  final String? idAnnee;
  const LecturesValidesPage({super.key, this.idAnnee});

  @override
  State<LecturesValidesPage> createState() => _LecturesValidesPageState();
}

class _LecturesValidesPageState extends State<LecturesValidesPage> {

  String idAnnee ="";
  Future<List<ProgrammeModel>> lectureValid() async{
    //recuperation de l'année actif
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('Parcours/AnneeActif').get();
    Map annee=snapshot.value as Map;
    idAnnee = annee['id'];


    List<ProgrammeModel> lecturesVld =[];
    final userId = FirebaseAuth.instance.currentUser?.uid;

    final event = await ref.child("Users/$userId/${widget.idAnnee}").once();
    for(var value in event.snapshot.children){
      ProgrammeModel child = ProgrammeModel.fromMap(value.value);
      lecturesVld.add(child);
    }
    return lecturesVld;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text(
        "Mes Lectures validées",
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 20.0,
          color: _mainColor,
        ),
      ),),
      body: FutureBuilder(
        future: lectureValid(),
        builder: (context , snapshot){
          List<ProgrammeModel> lecturesVld =[];

          if(snapshot.connectionState==ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(color: Colors.green,),
            );
          } else if(snapshot.hasData) {
            lecturesVld=snapshot.data as List<ProgrammeModel>;
            return ListView(
              children: lecturesVld.map((e){
                return ListeProgrammeWidget(element: e);
                // return Container();
              }).toList(),
            );

          }else{
            return const Center(
              child: Text('Un problème est survenue lors de la connexion...'),
            );
          }
        },
      ),
      );
  }
}
