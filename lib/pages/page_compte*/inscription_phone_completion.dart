import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vp_chretien/pages/switch_page.dart';

import '../../models/user_model.dart';
import 'connexion.dart';


const Color _mainColor= Color(0xFF446600);
class InscriptionPhoneCompletion extends StatefulWidget {
  final String numero;
  const InscriptionPhoneCompletion({super.key, required this.numero});

  @override
  State<InscriptionPhoneCompletion> createState() => _InscriptionPhoneCompletionState();
}

class _InscriptionPhoneCompletionState extends State<InscriptionPhoneCompletion> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _contactController = TextEditingController();
  final _villeController = TextEditingController();

  bool _isChecked = false;

  User? user = FirebaseAuth.instance.currentUser;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(color: Colors.grey.shade600,height: 40.0,),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Image(
                  image: AssetImage("images/vp1.jpg"),
                  height: 200.0,
                  width: 150,
                ),

                SizedBox(
                  height: 50.0,
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    cursorColor: Colors.blue,
                    controller: _nomController,
                    style: const TextStyle(
                        fontSize: 18.0
                    ),
                    decoration: InputDecoration(
                      focusColor: Colors.blue,
                      labelText: "Nom complet",
                      // hintText: "Adresse email",
                      labelStyle: TextStyle(color: Colors.grey.shade500,fontSize: 18.0),
                      enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          borderSide: BorderSide(color: Colors.blue,width: 2.0)
                      ),
                      focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          borderSide: BorderSide(color: Colors.blue,width: 2.0)
                      ),
                    ),
                    validator: (valeur){
                      if(valeur==null || valeur.isEmpty){
                        return "Veuillez saisir une valeur";
                      }
                      return null;

                    },
                  ),
                ),
                const SizedBox(height: 15.0,),
                SizedBox(
                  height: 50.0,
                  child: TextFormField(
                    keyboardType: TextInputType.none,
                    cursorColor: Colors.blue,
                    controller: _contactController,
                    style: const TextStyle(
                        fontSize: 18.0
                    ),
                    decoration: InputDecoration(
                      focusColor: Colors.blue,

                      hintText: widget.numero,
                      labelStyle: TextStyle(color: Colors.grey.shade500,fontSize: 18.0),
                      enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          borderSide: BorderSide(color: Colors.blue,width: 2.0)
                      ),
                      focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          borderSide: BorderSide(color: Colors.blue,width: 2.0)
                      ),
                    ),
                    validator: (valeur){
                      if(valeur==null || valeur.isEmpty){
                        return "Veuillez saisir une valeur";
                      }
                      return null;

                    },
                  ),
                ),
                const SizedBox(height: 15.0,),
                SizedBox(
                  height: 50.0,
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    cursorColor: Colors.blue,
                    controller: _villeController,

                    style: const TextStyle(
                        fontSize: 18.0
                    ),
                    decoration: InputDecoration(
                      focusColor: Colors.blue,
                      labelText: "Ville",
                      // hintText: "Adresse email",
                      labelStyle: TextStyle(color: Colors.grey.shade500,fontSize: 18.0),
                      enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          borderSide: BorderSide(color: Colors.blue,width: 2.0)
                      ),
                      focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          borderSide: BorderSide(color: Colors.blue,width: 2.0)
                      ),
                    ),
                    validator: (valeur){
                      if(valeur==null || valeur.isEmpty){
                        return "Veuillez saisir une valeur";
                      }
                      return null;

                    },
                  ),
                ),
                const SizedBox(height: 25.0,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(

                      width: 30.0,
                      height: 30.0,
                      decoration: const BoxDecoration(
                        color: _mainColor,
                      ),
                      child: Checkbox(
                          activeColor: _mainColor,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(0)),

                          ),
                          value: _isChecked,
                          onChanged: (value){
                            setState(() {
                              _isChecked = !_isChecked;
                            });

                          }
                      ),
                    ),

                    TextButton(
                      onPressed: (){
                        // la page des termes et conditions
                      },
                      child: const Column(
                        children: [

                          Text("Vous respectez le" , style: TextStyle(  color: _mainColor , fontSize: 15.0, fontWeight: FontWeight.normal),),
                          Text("Termes et Conditions", style: TextStyle( color: _mainColor , fontSize: 15.0, fontWeight: FontWeight.w700),),
                        ],
                      ),
                    ),
                  ],
                ),

                ElevatedButton(
                  onPressed: !_isChecked ? null : (){
                    postDetailsToFirestore();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const SwitchPage()));
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(double.maxFinite, 50.0),
                    backgroundColor:_mainColor,
                    shape: const RoundedRectangleBorder(

                      borderRadius: BorderRadius.all(Radius.circular(25)),
                    ),
                  ),
                  child: const Text("S'inscrire" , style: TextStyle( color: Colors.white , fontSize: 20.0, fontWeight: FontWeight.w600),),
                ),
                const SizedBox(height: 5.0,),
                TextButton(
                  onPressed: (){
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const Connexion(actif: false,)));
                  },
                  child: const Text("Vous avez déjà un compte?" , style: TextStyle( color: _mainColor , fontSize: 15.0, fontWeight: FontWeight.normal),),
                ),

                const SizedBox(height: 25.0,),
              ],
            ),
          ),
        ),
      ),
    );
  }



  void postDetailsToFirestore() async{
    DatabaseReference firebaseDatabase = FirebaseDatabase.instance.ref().child('Admin/Users');

    UserModel userModel = UserModel();

    userModel.uid = user?.uid;
    userModel.locality  = _villeController.text;
    userModel.mobile = user!.phoneNumber;
    userModel.name = _nomController.text;
    userModel.email=user!.phoneNumber;
    userModel.type = false;

    await firebaseDatabase.child(user!.uid).set(userModel.toMap())
        .then((value) => Fluttertoast.showToast(msg: "Compte créé avec succès"))
        .catchError((e)=>Fluttertoast.showToast(msg: "Erreur de connexion"))
    ;

    // await firebaseFirestore.collection("utilisateurs").doc(user.uid).set(userModel.toMap());

  }
}
