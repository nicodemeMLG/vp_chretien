import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:vp_chretien/pages/rapport_quiz.dart';
import 'package:vp_chretien/widgets/liste_statistique_widget.dart';
import '../models/livre_model.dart';
import 'lectures_valides_page.dart';
import 'note_par_date.dart';
import 'note_par_livre.dart';

Color _mainColor= const Color(0xFF446600);

class ListeStatistiquePage extends StatefulWidget {
  final int numPage;
  final List annees;
  const ListeStatistiquePage({super.key, required this.numPage, required this.annees});
  @override
  State<ListeStatistiquePage> createState() => _ListeStatistiquePageState();
}

class _ListeStatistiquePageState extends State<ListeStatistiquePage> {
  List searchResult = [];

  List<LivreModel> livres=[];
  Future<void> getLivres() async{
    List<LivreModel> meslivres=[];
    final ref=FirebaseDatabase.instance.ref();
    final snapshot = await ref.child("livres").get();

    for(var s in snapshot.children){
      LivreModel livre=LivreModel.fromMap(s.value as Map);
      // print(s.value);
      meslivres.add(livre);
    }
    livres=meslivres;
  }
  List quizNames=[];
  void getListTest() async{
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('tests').get();
    for(var q in snapshot.children){
      String? name = q.key;
      quizNames.add(name);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getAnnees();
    searchResult=widget.annees;
  }

  @override
  Widget build(BuildContext context) {
    // getAnnees();
    getListTest();
    getLivres();
    void func(String idAn){
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) {
          if(widget.numPage==1) {
            return LecturesValidesPage(idAnnee: idAn,);
          }
          if(widget.numPage==2) {
            return NoteParDate(idAnnee: idAn,);
          }
          if(widget.numPage==3) {
            return RapportQuiz(quiz:quizNames, idAnnee: idAn,);
          }
          if(widget.numPage==4) {
            return NoteParLivre(livres: livres,idAnnee: idAn,);
          }
          return const Placeholder();

        })
      );
    }
    // annees[0]['onTapFunction']=func;
    void searchListProgrammes(List donnees, String search){
      // searchResult=[];
      List result=[];
      if(search.isEmpty){
        result=donnees;
      }else{
        result=donnees.where((element){
          return element['intitule'].toString().toLowerCase().contains(search.toLowerCase());
        }).toList();
      }
      setState(() {
        // searchResult=[];
        searchResult = result;
      });
    }

    // print(searchResult);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Mes Statistiques",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 22.0,
            color: _mainColor,
          ),
        ),

      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(height: 10.0,),

              TextField(
                onChanged: (val) {
                  searchListProgrammes(widget.annees,val);
                  // print(searchResult);
                  setState(() {});
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


              const SizedBox(height: 15.0,),

              Container(
                height: 500.0,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.all(3.0),

                child: ListView.builder(

                  itemCount: searchResult.length,
                  itemBuilder: (context,index) =>ListeStatistiqueWidget(
                    titre: searchResult[index]['intitule'],
                    textCouleur: searchResult[index]['textColor'],
                    onTapFunction: (){
                      func(searchResult[index]['uid'].toString());
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
