import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vp_chretien/models/livre_model.dart';


import '../pages/lecture_page.dart';
import '../pages/note_livre.dart';
Color _mainColor= const Color(0xFF446600);
class ListeStatistiqueLivreWidget extends StatelessWidget {
  final LivreModel element;
  final String? idAnnee;
  const ListeStatistiqueLivreWidget({super.key, required this.element, this.idAnnee});



  //on doit ici savoir si la lecture du jour à été validé ou pas

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      decoration: BoxDecoration(
        border: BorderDirectional(
          top: BorderSide(
              color: _mainColor,
              width: 3.0
          ),
        ),
      ),
      child: ListTile(

        leading: const FaIcon(FontAwesomeIcons.bookBible , size: 25.0, color: Colors.purple,),
        title: Text(
          element.intitule??"" ,
          style: TextStyle(
            color: _mainColor,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),


        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
            return NoteLivre(livre: element,idAnnee: idAnnee);
          }));
        },
      ),
    );
  }
}
