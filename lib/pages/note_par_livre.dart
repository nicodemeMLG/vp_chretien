import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:vp_chretien/models/livre_model.dart';
import 'package:vp_chretien/widgets/liste_statistique_livre_widget.dart';


final Color _mainColor= Color(0xFF446600);
class NoteParLivre extends StatefulWidget {
  final List<LivreModel> livres;
  final String? idAnnee;
  const NoteParLivre({super.key, required this.livres, this.idAnnee});
  @override
  State<NoteParLivre> createState() => _NoteParLivreState();
}


class _NoteParLivreState extends State<NoteParLivre> {


  // List<LivreModel> livres=[];
  // void getLivres() async{
  //   List<LivreModel> meslivres=[];
  //   final ref=FirebaseDatabase.instance.ref();
  //   final snapshot = await ref.child("livres").get();
  //
  //   for(var s in snapshot.children){
  //     LivreModel livre=LivreModel.fromMap(s.value as Map);
  //     // print(s.value);
  //     meslivres.add(livre);
  //   }
  //   livres=meslivres;
  // }

  List<LivreModel> searchResult=[];

  @override
  void initState() {
    // TODO: implement initState
    // getLivres();
    searchResult=widget.livres;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    void searchListProgrammes(List<LivreModel> donnees, String search){
      List<LivreModel> result=[];
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


    // print(livres);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Mes notes",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20.0,
            color: _mainColor,
          ),
        ),
      ),
      backgroundColor: Colors.grey[100],

      body: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text("Cliquez sur un livre pour voir votre progression générale"),
              ),
              const SizedBox(height: 10.0,),

              Padding(
                padding: const EdgeInsets.only(top: 10.0,right: 20.0,left: 15.0, bottom: 10.0),
                child: TextField(

                  onChanged: (val){
                    searchListProgrammes(widget.livres, val);
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

              Flexible(
                child: FutureBuilder(

                  builder: (context , snapshot){
                    if(snapshot.connectionState==ConnectionState.waiting){
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.green,),
                      );
                    } else{

                      return ListView(
                        children: searchResult.map((e){
                          return ListeStatistiqueLivreWidget(element: e,idAnnee: widget.idAnnee);
                        }).toList(),
                      );
                    }
                  },
                ),
              ),
            ],
          ),


    );
  }
}
