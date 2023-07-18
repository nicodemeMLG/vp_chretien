import 'package:flutter/material.dart';

Color _mainColor= const Color(0xFF446600);
class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(

        backgroundColor: Colors.green[800],
        title: const Text("Contacts" ,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 23.0,
            color: Colors.white,
          ),),
      ),
      body: contacts(),
    );
  }
}

Widget contacts(){
  return Center(
    child: Container(
      // color: Colors.blue,
      height: 400.0,
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: [
          const Image(image: AssetImage("images/vp1.jpg")),
          const SizedBox(height: 25.0,),
          Text("Contacts : " , style: TextStyle(
            color: Colors.green[800],
          ),
          ),
          Text("(+226) 66 20 45 12 *** (+226) 70 20 14 91",style: TextStyle(
            color: Colors.grey[600],
          ),
          ),
          const SizedBox(height: 15.0,),
          Text("copyright 2023 VERTS PATURAGES" , style: TextStyle(
            color: _mainColor,
          ),
          ),
          Text("Tous droits réservés",style: TextStyle(
            color: Colors.grey[600],
          ),
          ),
        ],
      ),
    ),
  );
}


