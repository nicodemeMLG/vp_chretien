import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:vp_chretien/models/user_model.dart';
import 'package:vp_chretien/pages/home_page.dart';
import 'package:vp_chretien/pages/page_compte/connexion.dart';

class SwitchPage extends StatefulWidget {
  const SwitchPage({super.key});

  @override
  State<SwitchPage> createState() => _SwitchPageState();
}

class _SwitchPageState extends State<SwitchPage> {

  Future<String?> validateUser() async{
    final ref = FirebaseDatabase.instance.ref();
    String userId= FirebaseAuth.instance.currentUser!.uid;
    // print(userId);
    final snapshot1= await ref.child("Admin/Users/$userId").get();
    UserModel user = UserModel.fromMap(snapshot1.value as Map);
    return user.type;
  }

  @override
  Widget build(BuildContext context) {
    final isNotSmallScreen = MediaQuery.of(context).size.width >300;
    return FutureBuilder(
      future: validateUser(),
        builder: (context , snapshot){
          // print(snapshot.data);
          if(snapshot.data.toString()=="Oui"){
            return const HomePage();
          }else {
            // signOut();
            return const Connexion(actif: true);
          }
        }
    );
  }
}
