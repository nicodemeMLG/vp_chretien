import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const Color _mainColor= Color(0xFF446600);
class NoteParDate extends StatefulWidget {
  final String? idAnnee;
  const NoteParDate({super.key, required this.idAnnee});
  @override
  State<NoteParDate> createState() => _NoteParDateState();
}

class _NoteParDateState extends State<NoteParDate> {
  DateTime laDate= DateTime.now();
  final TextEditingController _textseacrch = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _textseacrch.text="Montant du : ${laDate.toString().split(" ")[0]}";
  }
  String idAnnee="";
  String cycle="";
  String userId = FirebaseAuth.instance.currentUser!.uid;

  Future<String> getNoteParDate(DateTime date) async{
    String noteParDate;
    String date=DateFormat("dd-MM-yyyy").format(laDate);
    final ref = FirebaseDatabase.instance.ref();
    //recuperation de l'id de l'année
    final snapshot1 = await ref.child('Parcours/AnneeActif').get();
    Map annee=snapshot1.value as Map;
    idAnnee = annee['id'];
    //recuperation du cycle
    final snapshot2= await ref.child("actifb").get();
    Map val = snapshot2.value as Map;
    cycle = val['actif'];
    //recuperation de l'id de l'utilisateur connecté

    final snapshot = await ref.child("lecturesParDate/$date/${widget.idAnnee}/$cycle/$userId").get();
    if(snapshot.value!=null){
      Map note=snapshot.value as Map;
      noteParDate=note['note'];
    }else{
      noteParDate="0";
    }
    return noteParDate;
  }
  void _showDatePicker(){
    showDatePicker( initialDate: laDate,currentDate: laDate, firstDate: DateTime(2000), lastDate: DateTime(2025), context: context )
        .then((value) async{
      setState(() {
        laDate=value!;
        _textseacrch.text="Montant du : ${laDate.toString().split(" ")[0]}";
      });
    }
    );
  }
  
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text(
          "Mes notes",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20.0,
            color: _mainColor,
          ),
        ),),
      backgroundColor: Colors.grey[100],
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const SizedBox(height: 10.0,),
            const SizedBox(
              width: double.maxFinite,
              child: Text("Cliquez sur l'icone du calendrier et choisissez une date pour voir le pourcentage"),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                controller: _textseacrch,
                cursorColor: Colors.blue,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal,
                  ),
                  decoration: InputDecoration(
                    fillColor: Colors.blue,
                    focusColor: Colors.blue,
                    hoverColor: Colors.blue,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_month_outlined , size: 40.0, color: Colors.blue,),
                      onPressed: _showDatePicker,
                    )
                  ),
              ),
            ),

            const SizedBox(height: 10.0,),
            Row(
              children: [
                FutureBuilder(
                  future: getNoteParDate(laDate),
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
                const Text("%" , style: TextStyle(fontSize: 16.0,color: _mainColor)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
