import 'dart:ffi';

import 'package:flutter/material.dart';

class DateWidget extends StatefulWidget {
  const DateWidget({super.key});

  @override
  State<DateWidget> createState() => _DateWidgetState();
}

class _DateWidgetState extends State<DateWidget> {
  final List<String> nomsMois=["Janvier","Février" , "Mars" , "Avril" , "Mai","Juin","Juillet" , "Août" , "Septembre" , "Octobre" , "Novembre" , "Decembre"];
  final List<String> nomsJours=["Lundi","Mardi","Mercredi","Jeudi","Vendredi","Samedi","Dimanche"];
  late String nomMois , nomJour;
  @override
  void initState(){
    super.initState();
    nomJour = "";
    nomMois="";
  }
  String getDate(){
    int numeroDate=0;
    int annee=0;
    var laDateDuJour="";
    DateTime date= DateTime.now();
    setState(() {
      nomMois = nomsMois[date.month -1];
      nomJour = nomsJours[date.weekday - 1];
      numeroDate = date.day;
      annee = date.year;
    });
    laDateDuJour = "$nomJour $numeroDate $nomMois $annee";
    return laDateDuJour;
  }
  @override
  Widget build(BuildContext context) {

    return Center(
      child: Text(
       getDate(),
        style: const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
    );
  }
}
