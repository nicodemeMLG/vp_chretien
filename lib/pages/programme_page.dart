import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vp_chretien/widgets/liste_programme_widget.dart';
import 'package:vp_chretien/models/programme_model.dart';

late DateTime? maDate;
class ProgrammePage extends StatefulWidget {
  final Map<String,DateTime?>? date;
  final VoidCallback funcNull;
  final String? cycle;
  const ProgrammePage({super.key, this.date, required this.funcNull, this.cycle});

  @override
  State<ProgrammePage> createState() => _ProgrammePageState();

}

class _ProgrammePageState extends State<ProgrammePage> {
  List<LectureModel> listeProgramme=[];
  List<LectureModel> listeProgrammeDate=[];
  void getProgrammes() async{
    List<LectureModel> programmes=[];
    String? cycle="";
    final ref = FirebaseDatabase.instance.ref().child("actifb");
    await ref.once().then((val) {
      Map value =val.snapshot.value as Map;
      cycle = value['actif'];
    });

    await FirebaseDatabase.instance.ref().child("lecturesParCycle/$cycle/lecture").once()
        .then((event){
      // print(event.snapshot.children);
      for ( var val in event.snapshot.children){
        LectureModel a=LectureModel.fromMap(val.value);
        // print(a.uid);
        programmes.add(a);
      }

    });
    listeProgramme = programmes;
  }

  void getProgrammesParDate() async{
    List<LectureModel> programmes=[];

    String date = DateFormat("dd-MM-yyyy").format(maDate!);


    await FirebaseDatabase.instance.ref().child("lecturesParDate/$date/lectures").once()
        .then((event){
      for ( var val in event.snapshot.children){
        LectureModel a=LectureModel.fromMap(val.value);

        programmes.add(a);

      }
    });
    listeProgrammeDate=programmes;

  }
  @override
  Widget build(BuildContext context) {
    String date="";
    if(widget.date!['date']!=null){
      maDate=widget.date!['date']!;
      date = DateFormat("dd-MM-yy").format(maDate!);
      getProgrammesParDate();
    }
    getProgrammes();
    return Scaffold(
      body: Container(
          child : widget.date!['date']==null ? Programme(elements: listeProgramme) :
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Les textes du $date"),
                    ElevatedButton(
                        onPressed: widget.funcNull,
                        child: const Text("Fermer")
                    ),
                  ],
                ),
              ),
              Flexible(child: Programme(elements: listeProgrammeDate),)
            ],
          )
      ),
    );
  }
}

class ContenuBody extends StatelessWidget{
  const ContenuBody({super.key});




  @override
  Widget build(BuildContext context){

    return FutureBuilder(
      // future: getProgrammes(),
        builder: (context , snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(color: Colors.green,),
            );
          } else if(snapshot.hasError){
            return Container();
          }
          else {
            return Programme(elements: snapshot.data as List<LectureModel>);
          }
        }
    );
  }
}

class ContenuParDateBody extends StatelessWidget{

  const ContenuParDateBody({super.key,});

  Future<List<LectureModel>> getProgrammes() async{
    List<LectureModel> programmes=[];

    String date = DateFormat("dd-MM-yyyy").format(maDate!);


    await FirebaseDatabase.instance.ref().child("lecturesParDate/$date/lectures").once()
        .then((event){
      for ( var val in event.snapshot.children){
        LectureModel a=LectureModel.fromMap(val.value);
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
            return Programme(elements: snapshot.data as List<LectureModel>);
          }
        }
    );
  }
}

class Programme extends StatefulWidget{

  final List<LectureModel> elements;

  const Programme({super.key, required this.elements});

  @override
  State<Programme> createState() => _ProgrammeState();
}

class _ProgrammeState extends State<Programme> {
  List<LectureModel> searchResult=[];
  bool initial = true;
  final searchText=TextEditingController();


  @override
  void initState() {
    super.initState();
    searchResult=widget.elements;
  }
  @override
  Widget build(BuildContext context){
    void searchListProgrammes(List<LectureModel> donnees, String search){
      initial = false;
      List<LectureModel> result=[];
      if(search.isEmpty){
        result=donnees;
      }else{
        result=donnees.where((element){
          return element.intitule.toString().toLowerCase().contains(search.toLowerCase());
        }).toList();
      }
      setState(() {
        initial = false;
        searchResult = result;
      });

    }


    // searchResult=widget.elements;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0,right: 20.0,left: 15.0, bottom: 10.0),
          child: TextField(

            onChanged: (val){

              searchListProgrammes(widget.elements, val);

            },
            controller: searchText,
            decoration: InputDecoration(
              hintText: "Recherchez ici",
              suffixIcon: IconButton(onPressed: (){
                setState(() {
                  searchText.text="";
                  searchResult=widget.elements;
              });}, icon: const Icon(Icons.close , size: 30,)),
              focusColor: Colors.blue,
              fillColor: Colors.blue,
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2.0) ,
              ),
            ),
            cursorColor: Colors.blue,

          ),

        ),
        FutureBuilder(
            builder: (context,snapshot){
              if(snapshot.connectionState==ConnectionState.waiting){
                return const Center(child: CircularProgressIndicator(color: Colors.green,),);
              }else{
                return Flexible(child: ListView(
                  children: initial? widget.elements.map((e){
                    return ListeProgrammeWidget(element: e);
                  }).toList(): searchResult.map((e){
                    return ListeProgrammeWidget(element: e);
                  }).toList(),
                ),);
              }
            }
        ),


      ],
    );
  }
}