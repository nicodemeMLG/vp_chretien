import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../models/livre_model.dart';

Color _mainColor= const Color(0xFF446600);
class NoteLivre extends StatefulWidget {
  final LivreModel livre;
  final String? idAnnee;
  const NoteLivre({super.key, required this.livre, this.idAnnee});

  @override
  State<NoteLivre> createState() => _NoteLivreState();
}

class _NoteLivreState extends State<NoteLivre> {
  String idAnnee="";

  Future<String> getNoteLivre() async{
    String noteParLivre="";
    //recupérer l'id de l'année
    final ref = FirebaseDatabase.instance.ref();
    final snapshot1 = await ref.child("Parcours/AnneeActif/id").get();
    idAnnee = snapshot1.value as String;

    String userId = FirebaseAuth.instance.currentUser!.uid;
    //recuperer la note du livre
    final snapshot2 = await ref.child("lecturesParLivre/${widget.livre.uid}/${widget.idAnnee}/$userId/note").get();
    noteParLivre = snapshot2.value as String;
    return noteParLivre;
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: _mainColor,
        title: Text(
          widget.livre.intitule??"",
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
      ),

      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15.0,),
            Text(
              widget.livre.intitule??"" ,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 30.0,
                color: _mainColor,
              ),
            ),

            const SizedBox(height: 15.0,),
            const Text(
              "Votre progression globale",
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 18.0,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 15.0,),
            Row(
              children: [
                FutureBuilder(
                  future: getNoteLivre(),
                  builder: (context , snapshot){
                    if(snapshot.connectionState==ConnectionState.waiting){
                      return const CircularProgressIndicator(color: Colors.green,);
                    }
                    else if(snapshot.hasData){
                      return Text(snapshot.data??"0", style: const TextStyle( fontSize: 50.0,color: Colors.green , fontWeight: FontWeight.w800),);
                    }
                    else{
                      return const Text("0", style: TextStyle( fontSize: 50.0,color: Colors.green , fontWeight: FontWeight.w800),);
                    }
                  },
                ),
                Text("%" , style: TextStyle(fontSize: 16.0,color: _mainColor)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
