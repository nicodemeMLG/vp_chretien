import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vp_chretien/widgets/liste_programme_widget.dart';
import 'package:vp_chretien/models/programme_model.dart';

late DateTime? maDate;
class ProgrammePage extends StatefulWidget {
  final Map<String,DateTime?>? date;

  const ProgrammePage({super.key, this.date});

  @override
  State<ProgrammePage> createState() => _ProgrammePageState();
}

class _ProgrammePageState extends State<ProgrammePage> {

  @override
  void initState() {
    // TODO: implement initState
    // widget.date?['date']=null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // maDate=!;
    // setState(() {});
    String date="";
    if(widget.date!['date']!=null){
      maDate=widget.date!['date']!;
      date = DateFormat("dd-MM-yy").format(maDate!);
    }

    return Scaffold(
      body: widget.date?['date']==null ? const ContenuBody():
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
    // String cycle="ancien";
    List<ProgrammeModel> programmes=[];
    // final ref = FirebaseDatabase.instance.ref().child("actifb");
    // await ref.once().then((val) {
    //   Map value =val.snapshot.value as Map;
    //   cycle = value['actif'];
    // });

    String date = DateFormat("dd-MM-yyyy").format(maDate!);
    // print(date);

    await FirebaseDatabase.instance.ref().child("lecturesParDate/$date/lectures").once()
        .then((event){

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

class Programme extends StatelessWidget{

  final List<ProgrammeModel> elements;

  const Programme({super.key, required this.elements});

  @override
  Widget build(BuildContext context){
    // print(elements.length);
    return ListView(
      children: elements.map((e){
        return ListeProgrammeWidget(element: e);
      }).toList(),
   );
  }
}
