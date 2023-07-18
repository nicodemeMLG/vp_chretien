import 'package:flutter/material.dart';

class PolitiquePage extends StatelessWidget {
  const PolitiquePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green[800],
        title: const Text("Politique de confidentialité" ,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 23.0,
            color: Colors.white,
          ),),
      ),

      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(5.0),
          child: const Text("Chargement..."),
        ),
      ),
    );
  }
}
