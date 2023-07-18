import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vp_chretien/controlleurs/function.dart';
import 'package:vp_chretien/pages/homePage.dart';
import 'package:vp_chretien/pages/page_compte*/inscription_email.dart';
import 'package:vp_chretien/pages/page_compte*/inscription_phone.dart';
import 'package:vp_chretien/pages/page_compte*/passe_oublie.dart';
import 'package:vp_chretien/pages/switch_page.dart';


Color _mainColor= const Color(0xFF446600);
class Connexion extends StatefulWidget {
  final bool actif;
  const Connexion({super.key,required this.actif});

  @override
  State<Connexion> createState() => _ConnexionState();
}

class _ConnexionState extends State<Connexion> {

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passeController = TextEditingController();
  bool _isObscure = true;
  bool _loading= false;

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        toolbarHeight: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(color: Colors.grey.shade600,height: 40.0,),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
              children: [
                const Image(
                  image: AssetImage("images/vp1.jpg"),
                  height: 250.0,
                  width: 150,
                ),
                widget.actif ? const Text("Votre compte n'est pas encore activé" , style: TextStyle(color: Colors.red,fontSize: 15.0),) :
                SizedBox(),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50.0,
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          cursorColor: Colors.blue,
                          controller: _emailController,
                          style: const TextStyle(
                              fontSize: 18.0
                          ),
                          decoration: InputDecoration(
                            focusColor: Colors.blue,
                            labelText: "Adresse email",
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
                            errorBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                borderSide: BorderSide(color: Colors.red,width: 2.0)
                            ),
                          ),
                          validator: (valeur){
                            if(valeur!.isEmpty){
                              return "Veuillez entrez votre adresse mail";
                            }
                            if(!RegExp("[a-zA-Z0-9+_.-]+@[a-zA-Z0-9_.]+.[a-z]").hasMatch(valeur)){
                              return "Veuillez entrez une adresse valide";
                            }
                            return null;

                          },
                        ),
                      ),
                      const SizedBox(height: 25.0,),

                      SizedBox(
                        height: 50.0,
                        child: TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          cursorColor: Colors.blue,
                          controller: _passeController,
                          obscureText: _isObscure ? true:false,
                          style: const TextStyle(
                              fontSize: 18.0
                          ),
                          decoration: InputDecoration(
                              focusColor: Colors.blue,
                              labelText: "Mot de passe",
                              // hintText: "Votre mot de passe",
                              labelStyle: TextStyle(color: Colors.grey.shade500,fontSize: 18.0),
                              enabledBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                  borderSide: BorderSide(color: Colors.blue,width: 2.0)
                              ),
                              focusedBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                  borderSide: BorderSide(color: Colors.blue,width: 2.0)
                              ),
                              errorBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                  borderSide: BorderSide(color: Colors.red,width: 2.0)
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.remove_red_eye_rounded , color: _isObscure? Colors.grey:Colors.blue,),
                                onPressed: () {
                                  setState(() {
                                    _isObscure= _isObscure==true?false : true;
                                  });
                                },
                              )
                          ),
                          validator: (valeur){
                            if(valeur!.isEmpty){
                              return "Veuillez saisir le mot de passe";
                            }
                            return null;

                          },
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const PasseOublie()));
                            },
                            child: Text("Mot de passe oublié?" , style: TextStyle( color: _mainColor , fontSize: 18.0, fontWeight: FontWeight.w600),),
                          ),
                        ],
                      ),

                      ElevatedButton(
                        onPressed: _loading ? null : (){
                          signIn(_emailController.text, _passeController.text);
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(double.maxFinite, 50.0),
                          backgroundColor: _mainColor,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                          ),
                        ),
                        child:  _loading?
                        const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ) :  const Text('Connexion' , style: TextStyle( color: Colors.white , fontSize: 20.0, fontWeight: FontWeight.w600),),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20.0,),
                TextButton(
                  onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> InscriptionEmail()));
                  },

                  child: Text("S'inscrire avec un EMAIL" , style: TextStyle( color: _mainColor , fontSize: 18.0, fontWeight: FontWeight.w600),),
                ),
                const SizedBox(height: 35.0,),
                TextButton(
                  onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> InscriptionPhone()));
                  },
                  child: Text("Se connecter avec le TELEPHONE" , style: TextStyle( color: _mainColor , fontSize: 18.0, fontWeight: FontWeight.w600),),
                ),
              ]
          ),
        ),
      ),
    );
  }

  void signIn(String email, String password) async{
    _loading = true;
    setState(() {});
    if(_formKey.currentState!.validate()){
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid){
            Fluttertoast.showToast(msg: "Connecté avec succès");
            _loading = false;
            setState(() {});
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const SwitchPage()));
          })
          .catchError((e){
            _loading = false;
            setState(() {});
            Fluttertoast.showToast(msg: "Connexion echouée");
      })
      ;
    }
  }
}
