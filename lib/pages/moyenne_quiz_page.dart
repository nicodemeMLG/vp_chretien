import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';


final Color _mainColor= Color(0xFF446600);
class MoyenneQuizPage extends StatefulWidget {
  final String quiz;
  final String idAnnee;
  const MoyenneQuizPage({super.key, required this.quiz, required this.idAnnee});

  @override
  State<MoyenneQuizPage> createState() => _MoyenneQuizPageState();
}

class _MoyenneQuizPageState extends State<MoyenneQuizPage> {

  Future<String> getMoyenne()async{
    String note="";
    final ref = FirebaseDatabase.instance.ref();
    // Results/$intitule/$anneeActif/$userId


    String userId=FirebaseAuth.instance.currentUser!.uid;
    final snapshot = await ref.child('Results/${widget.quiz}/${widget.idAnnee}/$userId/note').get();
    note = snapshot.value as String;

    return note;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: _mainColor,
        title: Text(
          widget.quiz,
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
              widget.quiz,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 30.0,
                color: _mainColor,
              ),
            ),

            const SizedBox(height: 15.0,),
            const Text(
              "Votre moyenne : ",
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
                  future: getMoyenne(),
                    builder: (context,snapshot){
                      if(snapshot.connectionState==ConnectionState.waiting){
                        return const CircularProgressIndicator(color: Colors.green,);
                      }else if(snapshot.hasData){
                        return Text(snapshot.data??"0", style: const TextStyle( fontSize: 50.0,color: Colors.green , fontWeight: FontWeight.w800),);

                      }else {
                        return const SizedBox();
                      }
                    }
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
