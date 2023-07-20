import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:vp_chretien/widgets/liste_programme_widget.dart';
import 'package:vp_chretien/models/programme_model.dart';


late DateTime? maDate;
const Color _mainColor= Color(0xFF446600);
class ProgrammePage2 extends StatefulWidget {
  final String? cycle;
  const ProgrammePage2({super.key, required this.cycle});

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
  List<ProgrammeModel> listeProgramme=[];
  Future<List<ProgrammeModel>> getProgrammes() async{
    List<ProgrammeModel> programmes=[];

    await FirebaseDatabase.instance.ref().child("lecturesParCycle/${widget.cycle}/lecture").once()
        .then((event){
      // print(event.snapshot.children);
      for ( var val in event.snapshot.children){
        ProgrammeModel a=ProgrammeModel.fromMap(val.value);
        // print(a.uid);
        programmes.add(a);
      }

    });
    return programmes;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Lecture de la bible",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 22.0,
            color: _mainColor,
          ),
        ),
      ),
      body: FutureBuilder(
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
      ),
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

