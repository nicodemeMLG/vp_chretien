import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vp_chretien/pages/page_compte*/connexion.dart';
import 'package:vp_chretien/widgets/liste_programme_widget.dart';
import 'package:vp_chretien/models/programme_model.dart';

import '../controlleurs/function.dart';

late DateTime? maDate;
final Color _mainColor= Color(0xFF446600);
class ProgrammePage2 extends StatefulWidget {
  final Map<String,DateTime?>? date;
  final List<ProgrammeModel> lectures;

  const ProgrammePage2({super.key, this.date, required this.lectures});

  @override
  State<ProgrammePage2> createState() => _ProgrammePage2State();
}

class _ProgrammePage2State extends State<ProgrammePage2> {
  @override
  void initState() {
    // TODO: implement initState
    // widget.date?['date']=null;
    super.initState();
  }

  List<ProgrammeModel> searchResult = [];
  void searchListProgrammes(List<ProgrammeModel> donnees, String search){
    List<ProgrammeModel> result=[];
    if(search.isEmpty){
      result=donnees;
    }else{
      result=donnees.where((element){
        return element.intitule.toString().toLowerCase().contains(search.toLowerCase());
      }).toList();
    }
    setState(() {
      searchResult = result;
    });

  }

  @override
  Widget build(BuildContext context) {

    String date="";
    if(widget.date!['date']!=null){
      maDate=widget.date!['date']!;
      date = DateFormat("dd-MM-yy").format(maDate!);
    }

    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0,right: 20.0,left: 15.0, bottom: 10.0),
                child: TextField(
                  onChanged: (val){
                    searchListProgrammes(widget.lectures, val);
                  },
                  decoration: const InputDecoration(
                    hintText: "Recherchez ici",
                    suffixIcon: Icon(Icons.close , size: 40,),
                    focusColor: Colors.blue,
                    fillColor: Colors.blue,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0) ,
                    ),
                  ),
                  cursorColor: Colors.blue,
                ),
              ),
            ],
          ),

          widget.date?['date']==null ? const ContenuBody():
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Les textes du $date"),
                    ElevatedButton(
                        onPressed: (){
                          setState(() {

                            widget.date?['date']=null;
                            maDate=null;
                          });
                        },
                        child: const Text("Fermer")
                    ),
                  ],

                ),
              ),
              const Flexible(child: ContenuParDateBody(),)

            ],
          ),
        ],
      ),
    );
  }
}

class ContenuBody extends StatelessWidget{
  const ContenuBody({super.key});


  Future<List<ProgrammeModel>> getProgrammes() async{
    String cycle="ancien";
    List<ProgrammeModel> programmes=[];
    final ref = FirebaseDatabase.instance.ref().child("actifb");
    await ref.once().then((val) {
      Map value =val.snapshot.value as Map;
      cycle = value['actif'];
    });

    await FirebaseDatabase.instance.ref().child("lecturesParCycle/$cycle/lecture").once()
        .then((event){
      // print(event.snapshot.children);
      for ( var val in event.snapshot.children){
        ProgrammeModel a=ProgrammeModel.fromMap(val.value);
        // print(a.uid);
        programmes.add(a);
      }
      // print(programmes);
    });
    return programmes;
  }

  @override
  Widget build(BuildContext context){

    return FutureBuilder(
        future: getProgrammes(),
        builder: (context , snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(color: Colors.green,),
            );
          } else if(snapshot.hasError){
            return Container();
          }
          else {
            return Programme(elements: snapshot.data as List<ProgrammeModel>);
          }
        }
    );
  }
}

class ContenuParDateBody extends StatelessWidget{


  const ContenuParDateBody({super.key,});



  Future<List<ProgrammeModel>> getProgrammes() async{
    List<ProgrammeModel> programmes=[];

    String date = DateFormat("dd-MM-yyyy").format(maDate!);


    await FirebaseDatabase.instance.ref().child("lecturesParDate/$date/lectures").once()
        .then((event){
      for ( var val in event.snapshot.children){
        ProgrammeModel a=ProgrammeModel.fromMap(val.value);
        programmes.add(a);
      }
    });
    return programmes;
  }

  @override
  Widget build(BuildContext context){

    return FutureBuilder(
        future: getProgrammes(),
        builder: (context , snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(color: Colors.green,),
            );
          } else if(snapshot.hasError){
            return Container();
          }
          else {
            return Programme(elements: snapshot.data as List<ProgrammeModel>);
          }
        }
    );

  }
}

class Programme extends StatelessWidget{

  final List<ProgrammeModel> elements;

  const Programme({super.key, required this.elements});

  @override
  Widget build(BuildContext context){
    return ListView(
      children: elements.map((e){
        return ListeProgrammeWidget(element: e);
      }).toList(),
    );
  }
}

