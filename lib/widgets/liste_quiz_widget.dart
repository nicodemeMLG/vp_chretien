import 'package:flutter/material.dart';

import '../pages/moyenne_quiz_page.dart';


Color mainColor= const Color(0xFF446600);
class ListeQuizWidget extends StatelessWidget {
  final String element;
  final String idAnnee;
  const ListeQuizWidget({super.key, required this.element, required this.idAnnee});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0,
      margin: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
      // padding: const EdgeInsets.all(7.0),
      decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 2,
              offset: Offset(0,2),
            ),
          ]

      ),

      child: Center(
        child: ListTile(

          leading: const Icon(Icons.lightbulb_outline , size: 25.0, color: Colors.white,),
          title: Text(
            element ,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15.0,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),

          trailing: ElevatedButton(
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MoyenneQuizPage(quiz: element,idAnnee: idAnnee)));
            },
            style: ElevatedButton.styleFrom(

              backgroundColor: Colors.deepPurpleAccent,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            child: const Text("Moyenne" , style: TextStyle( fontSize: 16.0 , color: Colors.white),),
          ),

        ),
      ),
    );
  }
}
