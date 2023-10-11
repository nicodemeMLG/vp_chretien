import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vp_chretien/pages/lectures_non_valides_page.dart';
import 'package:vp_chretien/pages/lectures_valides_page.dart';
import 'package:vp_chretien/widgets/date_widget.dart';
import 'package:vp_chretien/widgets/liste_programme_jour_widget.dart';
import 'package:vp_chretien/widgets/slider_widget.dart';

Color mainColor= const Color(0xFF446600);

class MyHomePage extends StatefulWidget{
  final List programmejour;
  final String? anneeActif;
  const MyHomePage({super.key, required this.programmejour, this.anneeActif});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  final String? userId=FirebaseAuth.instance.currentUser?.uid;
  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }
  late String cycle;
  late String noteParCycle;
  late String noteParDate;
  String date=DateFormat("dd-MM-yyyy").format(DateTime.now());

  void getCycle() async{
    final ref = FirebaseDatabase.instance.ref().child("actifb");
    final snapshot= await ref.get();
    Map val = snapshot.value as Map;
    cycle = val['actif'];
  }

  void getNoteParDate() async{
    final refParDate = FirebaseDatabase.instance.ref().child("lecturesParDate/$date/${widget.anneeActif}/$cycle/$userId");
    final snapshot = await refParDate.get();
    Map? valueDate = snapshot.value!=null ? snapshot.value as Map : {};
    noteParDate= valueDate['note']??"0";
  }

  void getNoteParCycle() async{
    final refParCycle = FirebaseDatabase.instance.ref().child("lecturesParCycle/$cycle/${widget.anneeActif}/$userId");
    refParCycle.onValue.listen((event) {
      if(event.snapshot.value!=null) {
        Map valueCycle =event.snapshot.value as Map;
        noteParCycle = valueCycle['note'];
      }else{
        noteParDate="0";
      }

    });
  }
  @override
  void initState() {
    // TODO: implement initState
    cycle="";
    noteParCycle="0";
    noteParDate="0";
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    getCycle();
    getNoteParCycle();
    getNoteParDate();
    // print(noteParDate);

    return Scaffold(
      body: Container(
        color: mainColor,
        height: double.infinity,
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox( height: 5.0, ),
            const DateWidget(),

            Container(
              color: Colors.white,

              padding: const EdgeInsets.all(5.0),
              margin: const EdgeInsets.only(bottom: 5.0),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const SliderWidget(),
                  const Text("ANCIEN TESTAMENT",style: TextStyle(color: Colors.green, fontSize: 17.0),),
                  Text("Progression générale: $noteParCycle%",style: const TextStyle(color: Colors.green, fontSize: 17.0,fontWeight: FontWeight.w700),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LecturesValidesPage(idAnnee: widget.anneeActif,)));
                        },
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(2.0),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(0)),
                            ),
                            side: const BorderSide(color: Colors.grey)
                        ), child: Row(
                        children: [
                          Container(
                            width:30,
                            height: 30,

                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(15)
                            ),
                            child: const Icon(
                              Icons.check,
                              size: 25.0,
                              color: Colors.white,
                            ),
                          ),
                          const Text("Lectures validées",overflow: TextOverflow.ellipsis ,style: TextStyle(color: Colors.black, fontSize: 15.0,fontWeight: FontWeight.w500),)
                        ],
                      ),
                      ),

                      ElevatedButton(
                        onPressed: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LecturesNonValidesPage(anneeActif: widget.anneeActif)));
                        },
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(2.0),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(0)),
                            ),
                            side: const BorderSide(color: Colors.grey)
                        ), child: Row(
                        children: [
                          Container(
                            width:30,
                            height: 30,
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(15)
                            ),
                            child: const Icon(
                              Icons.clear,
                              size: 25.0,
                              color: Colors.white,
                            ),
                          ),
                          const Text("Lectures non validées",overflow: TextOverflow.ellipsis ,style: TextStyle(color: Colors.black, fontSize: 15.0,fontWeight: FontWeight.w500),)
                        ],
                      ),
                      ),

                    ],
                  ),

                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 10.0,),
              child: Text(
                "Programme du jour: $noteParDate% ($cycle test.)" ,
                textAlign: TextAlign.start,
                style: const TextStyle(color: Colors.white ,
                  fontWeight: FontWeight.w700 ,
                  fontSize: 17.0,
                ),
              ),
            ),
            Flexible(child: SingleChildScrollView(child: ProgrammeSection(element: widget.programmejour, anneeActif: widget.anneeActif.toString(),),),)
          ],
        ),
      ),


    );
  }
}

class ProgrammeSection extends StatelessWidget{
  final List element;
  final String anneeActif;
  const ProgrammeSection({super.key, required this.element, required this.anneeActif});

  @override
  Widget build(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: element.map((e){
        return ListeProgrammeJourWidget(element: e,anneeActif:anneeActif);
      }).toList(),

    );
  }
}