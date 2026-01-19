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
    super.initState();
    getAnnees();
  }

  @override
  void dispose() {
    getAnnees();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    getAnnees();
    final isNotSmallScreen = MediaQuery.of(context).size.width >300;
    return Scaffold(
  backgroundColor: Colors.grey[50],
  body: SafeArea(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const SizedBox(height: 16.0),
          
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.22,
              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(
                "images/stat.png",
                fit: BoxFit.contain,
              ),
            ),
          ),
          
          const SizedBox(height: 24.0),
          
          // Progression
          Text(
            "Progression générale",
            style: TextStyle(
              fontSize: isNotSmallScreen ? 13.0 : 11.0,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6.0),
          Text(
            "${widget.progression}%",
            style: TextStyle(
              fontSize: isNotSmallScreen ? 40.0 : 32.0,
              color: _mainColor,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.0,
            ),
          ),
          
          const SizedBox(height: 32.0),
          
          // Boutons
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: ButtonWidget(
                      titre: "MES LECTURES VALIDEES",
                      onPressedFunction: (){
                        if(!context.mounted) return;
                        lectureValidee();
                      } ,
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: ButtonWidget(
                      titre: "NOTE PAR DATE",
                      onPressedFunction: (){
                        if(!context.mounted) return;
                        notePage();
                      
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              Row(
                children: [
                  Expanded(
                    child: ButtonWidget(
                      titre: "NOTE PAR QUIZ",
                      onPressedFunction: (){
                        if(!context.mounted) return;
                        noteQuiz();
                      },
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: ButtonWidget(
                      titre: "NOTE PAR LIVRE",
                      onPressedFunction: (){
                        if(!context.mounted) return;
                        noteLivre();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  ),
);
  }
}