import 'dart:async';

import 'package:flutter/material.dart';

class ValidationContenuWidget extends StatefulWidget {
  final DateTime dateValid;
  const ValidationContenuWidget({super.key, required this.dateValid});

  @override
  State<ValidationContenuWidget> createState() => _ValidationContenuWidgetState();
}

class _ValidationContenuWidgetState extends State<ValidationContenuWidget> {
  late DateTime dateActu ;
  late int jours=0, heures=0, minutes=0, secondes=0;
  Timer? _timer;

  @override
  void initState(){
    super.initState();
    _startTimer();
  }

  @override
  void dispose(){
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer(){
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) async{
      setState(() {
        dateActu=DateTime.now();
        Duration diff = widget.dateValid.difference(dateActu);
        jours = diff.inDays;
        heures = diff.inHours%24;
        minutes  = diff.inMinutes % 60;
        secondes = diff.inSeconds % 60;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    final isNotSmallScreen = MediaQuery.of(context).size.width >300;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       Text(
          "Disponible dans",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: isNotSmallScreen?18.0:13.0,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],


          ),
        ),


       Row(
          children: [
            compteur("Jours", jours),
            compteur("Heures", heures),
            compteur("Minutes", minutes),
            compteur("Secondes", secondes),
          ],

        ),

        const SizedBox(height: 10.0,),

        const SizedBox(height: 5.0,),

        Divider(
          height: 8.0,
          color: Colors.grey.shade400,
        ),

        //Text("${jours} ; ${heures} ; ${minutes} ; ${secondes}"),
      ],
    );
  }
  Widget compteur(String titre, int valeur){
    final isNotSmallScreen = MediaQuery.of(context).size.width >300;
    return Container(
      width: MediaQuery.of(context).size.width * 0.22,
      //height: 80,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(width: 2.0,color: Colors.grey.shade400),
      ),
      child: Column(
        children: [
          Text(valeur.toString(),
            style: TextStyle(
              color: Colors.black,
              fontSize: isNotSmallScreen?18.0:13.0,
              //height: 25,
              fontWeight: FontWeight.bold,

          ),),
          Text(titre,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.purple,
              fontSize: isNotSmallScreen?14.0:9.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
