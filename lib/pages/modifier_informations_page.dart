import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vp_chretien/pages/profile_page.dart';
import '../controlleurs/function.dart';
import '../models/user_model.dart';

Color _mainColor= const Color(0xFF446600);
class ModifierInformationsPage extends StatefulWidget {
  final UserModel user;

  const ModifierInformationsPage({super.key, required this.user});

  @override
  State<ModifierInformationsPage> createState() => _ModifierInformationsPageState();
}

class _ModifierInformationsPageState extends State<ModifierInformationsPage> {
  final _formKey = GlobalKey<FormState>();
  final nomController = TextEditingController();
  final telephoneController = TextEditingController();
  final emailController = TextEditingController();
  final villeController = TextEditingController();



  @override
  void dispose(){
    nomController.dispose();
    telephoneController.dispose();
    emailController.dispose();
    villeController.dispose();

    super.dispose();
  }

  @override
  void initState(){
    super.initState();
    nomController.text=widget.user.name.toString()??"";
    telephoneController.text = widget.user.mobile.toString()??"";
    emailController.text= widget.user.email.toString()??"";
    villeController.text = widget.user.locality.toString()??"";


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green[800],
        title: const Text("Modifier mes informations" ,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 23.0,
            color: Colors.white,
          ),),
      ),
      body: Container(
        margin: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Column(
                children: [
                  SizedBox(
                    height: 50.0,
                    child: TextFormField(
                      cursorColor: Colors.blue,
                      controller: nomController,
                      style: const TextStyle(
                          fontSize: 18.0
                      ),
                      decoration: InputDecoration(
                        focusColor: Colors.blue,
                        labelText: "Nom complet",
                        labelStyle: TextStyle(color: Colors.grey.shade500,fontSize: 18.0),
                        enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15.0)),
                            borderSide: BorderSide(color: Colors.blue,width: 2.0)
                        ) ,
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

                  const SizedBox(height: 20.0,),
                  SizedBox(
                    height: 50.0,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: telephoneController,
                      style: const TextStyle(
                          fontSize: 18.0
                      ),
                      decoration: InputDecoration(
                        labelText: "Téléphone",
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

                  const SizedBox(height: 20.0,),
                  SizedBox(
                    height: 50.0,
                    child: TextFormField(
                      controller: emailController,
                      style: const TextStyle(
                          fontSize: 18.0
                      ),
                      readOnly: true,
                      decoration: InputDecoration(

                        labelText: "Email",

                        labelStyle: TextStyle(color: Colors.grey.shade500 , fontSize: 18.0),

                        enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15.0)),
                            borderSide: BorderSide(color: Colors.blue,width: 2.0)
                        ) ,

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

                  const SizedBox(height: 20.0,),
                  SizedBox(
                    height: 50.0,
                    child: TextFormField(
                      style: const TextStyle(
                        fontSize: 18.0
                      ),
                      controller: villeController,
                      decoration: InputDecoration(
                        labelText: "Ville",
                        labelStyle: TextStyle(color: Colors.grey.shade500,fontSize: 18.0),
                        enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15.0)),
                            borderSide: BorderSide(color: Colors.blue,width: 2.0)
                        ) ,
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


                ],
              ),

              ElevatedButton(
                onPressed: () {
                  if(_formKey.currentState!.validate()){
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   const SnackBar(content: Text("Validation..."))
                    // );
                    // FocusScope.of(context).requestFocus(FocusNode());
                    // Navigator.of(context).pop();
                    widget.user.name = nomController.text;
                    widget.user.email = emailController.text;
                    widget.user.mobile = telephoneController.text;
                    widget.user.locality = villeController.text;
                    updateUserProfil(widget.user.toMap());
                    Navigator.of(context).pop();
                  }
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(double.maxFinite, 55.0),
                  backgroundColor: Colors.green,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                  ),
                ),
                child: const Text(
                  'Valider',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }

}

