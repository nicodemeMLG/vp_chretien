import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


Color mainColor= const Color(0xFF446600);

class ListeStatistiqueWidget extends StatelessWidget {
  final Color textCouleur;
  final VoidCallback? onTapFunction;
  final String titre;
  const ListeStatistiqueWidget({super.key,required this.titre, required this.textCouleur, this.onTapFunction});



  @override
  Widget build(BuildContext context) {
    final isNotSmallScreen = MediaQuery.of(context).size.width >300;
    return Container(
      height: 60.0,
      decoration: BoxDecoration(
        border: BorderDirectional(
          bottom: BorderSide(
              color: mainColor,
              width: 2.0
          ),
        ),
      ),
      child: ListTile(

        leading: const FaIcon(FontAwesomeIcons.bookBible , size: 20.0, color: Colors.purple,),
        title: Text(
          titre ,
          style: TextStyle(
            color: textCouleur,
            fontSize: isNotSmallScreen?14.0:8.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        onTap: onTapFunction,
      ),
    );
  }
}