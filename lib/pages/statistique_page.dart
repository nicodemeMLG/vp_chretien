import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:vp_chretien/pages/liste_statistique_page.dart';
import 'package:vp_chretien/widgets/bouton_widget.dart';

const Color _mainColor= Color(0xFF446600);
class StatistiquePage extends StatefulWidget {
  final String progression;
  const StatistiquePage({super.key, required this.progression,});

  @override
  State<StatistiquePage> createState() => _StatistiquePageState();
}

class _StatistiquePageState extends State<StatistiquePage> {

  List annees=[];
  String actif="";
  void getAnnees() async{
    List mesannees=[];
    final ref=FirebaseDatabase.instance.ref();
    final snapshot1 = await ref.child("/Parcours/AnneeActif/id").get();
    actif = snapshot1.value as String;
    final snapshot2 = await ref.child("Parcours/Annees").get();
      for(var s in snapshot2.children){
        Map annee = s.value as Map;
        annee['textColor']= actif==annee['uid']?Colors.yellow:Colors.grey.shade700 ;
        mesannees.add(annee);
      }

    annees=mesannees;
  }
  void lectureValidee(){
    Navigator.of(context).push(MaterialPageRoute(builder: (builder)=>  ListeStatistiquePage( numPage: 1, annees: annees,)));
  }
  void notePage(){
    Navigator.of(context).push(MaterialPageRoute(builder: (builder)=> ListeStatistiquePage(numPage: 2,annees: annees,)));
  }
  void noteQuiz(){
    Navigator.of(context).push(MaterialPageRoute(builder: (builder)=> ListeStatistiquePage(numPage: 3,annees: annees,)));
  }
  void noteLivre(){
    Navigator.of(context).push(MaterialPageRoute(builder: (builder)=> ListeStatistiquePage(numPage: 4,annees: annees,)));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAnnees();
  }

  @override
  Widget build(BuildContext context) {

    getAnnees();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40.0,),
              Image(
                  image: const AssetImage("images/stat.png"),
                height: MediaQuery.of(context).size.height*0.3,
              ),
              const SizedBox(height: 25.0,),
              Text(
                "Progression générale: ${widget.progression}%",
                style: const TextStyle(
                  fontSize: 15.0,
                  color: _mainColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 50.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ButtonWidget(titre: "MES LECTURES VALIDEES", onPressedFunction: lectureValidee,),
                  ButtonWidget(titre: "NOTE PAR DATE", onPressedFunction: notePage,),
                ],
              ),

              const SizedBox(height: 25),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ButtonWidget(titre: "NOTE PAR QUIZ", onPressedFunction: noteQuiz,),
                  ButtonWidget(titre: "NOTE PAR LIVRE", onPressedFunction: noteLivre,),
                ],
              ),

            ],
          ),

        ),
      ),
    );
  }
}