import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vp_chretien/models/user_model.dart';
import 'package:vp_chretien/pages/page_compte/connexion.dart';
import 'package:vp_chretien/services/auth_service.dart';

Color _mainColor= const Color(0xFF446600);
class InscriptionEmail extends StatefulWidget {
  const InscriptionEmail({super.key});

  @override
  State<InscriptionEmail> createState() => _InscriptionEmailState();
}

class _InscriptionEmailState extends State<InscriptionEmail> {
  
  final _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactController = TextEditingController();
  final _villeController = TextEditingController();
  final _passeController = TextEditingController();
  final _confirmPasseController = TextEditingController();
  bool _isObscure1 = true, _isObscure2 = true , _isChecked=false , loading=false;
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
                      errorBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          borderSide: BorderSide(color: Colors.red,width: 2.0)
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
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: Colors.blue,
                    controller: _emailController,

                    style: const TextStyle(
                        fontSize: 18.0
                    ),
                    decoration: InputDecoration(
                      focusColor: Colors.blue,
                      labelText: "Email",
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
                    keyboardType: TextInputType.phone,
                    cursorColor: Colors.blue,
                    controller: _contactController,
                    style: const TextStyle(
                        fontSize: 18.0
                    ),
                    decoration: InputDecoration(
                      focusColor: Colors.blue,
                      labelText: "Contact",
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
                      errorBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          borderSide: BorderSide(color: Colors.red,width: 2.0)
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
                    keyboardType: TextInputType.visiblePassword,
                    cursorColor: Colors.blue,
                    controller: _passeController,
                    obscureText: _isObscure1 ? true:false,

                    style: const TextStyle(
                        fontSize: 18.0
                    ),
                    decoration: InputDecoration(
                        focusColor: Colors.blue,
                        labelText: "Créer un Mot de passe",
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
                          icon: Icon(Icons.remove_red_eye_rounded , color: _isObscure1? Colors.grey:Colors.blue,),
                          onPressed: () {
                            setState(() {
                              _isObscure1= _isObscure1==true?false : true;
                            });
                          },
                        )
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
                    keyboardType: TextInputType.visiblePassword,
                    cursorColor: Colors.blue,
                    controller: _confirmPasseController,
                    obscureText: _isObscure2 ? true:false,
                    style: const TextStyle(
                        fontSize: 18.0
                    ),
                    decoration: InputDecoration(
                        focusColor: Colors.blue,
                        labelText: "Confirmer Mot passe",
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
                          icon: Icon(Icons.remove_red_eye_rounded , color: _isObscure2? Colors.grey:Colors.blue,),
                          onPressed: () {
                            setState(() {
                              _isObscure2= _isObscure2==true?false : true;
                            });
                          },
                        )
                    ),
                    validator: (valeur){
                      if(_passeController.text != valeur){
                        return "Le mot de passe est different du premier";
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
                      decoration: BoxDecoration(
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
                      child: Column(
                        children: [

                          Text("Vous respectez le" , style: TextStyle(  color: _mainColor , fontSize: 15.0, fontWeight: FontWeight.normal),),
                          Text("Termes et Conditions", style: TextStyle( color: _mainColor , fontSize: 15.0, fontWeight: FontWeight.w700),),
                        ],
                      ),
                    ),





                  ],
                ),

                ElevatedButton(
                  onPressed: !_isChecked || loading ? null :
                      (){
                        if(_formKey.currentState!.validate()){
                          signUp(_emailController.text, _passeController.text);
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> const Connexion(actif: false,)), (route) => false);
                        }
                      },
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(double.maxFinite, 50.0),
                    backgroundColor: !_isChecked? Colors.grey : _mainColor,
                    shape: const RoundedRectangleBorder(

                      borderRadius: BorderRadius.all(Radius.circular(25)),
                    ),
                  ),
                  child:loading?
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ) : const Text("S'inscrire" , style: TextStyle( color: Colors.white , fontSize: 20.0, fontWeight: FontWeight.w600),),
                ),
                const SizedBox(height: 5.0,),
                TextButton(
                  onPressed: (){
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const Connexion(actif: false,)));
                  },
                  child: Text("Vous avez déjà un compte?" , style: TextStyle( color: _mainColor , fontSize: 15.0, fontWeight: FontWeight.normal),),
                ),

                const SizedBox(height: 25.0,),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  void signUp(String email,String password) async{
    loading=true;
    setState(() {});
    // if(_formKey.currentState!.validate()){
      await _auth.createUserWithEmailAndPassword(email: email, password: password)
          .then((value){
            postDetailsToFirestore();
            loading=false;
            setState(() {});
          })
          .catchError((e){
            loading=false;
            setState(() {});
            Fluttertoast.showToast(msg: e!.message);
      });
    // }
  }

  postDetailsToFirestore() async{
    // FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    UserModel userModel = UserModel();

    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.locality  = _villeController.text;
    userModel.mobile = _contactController.text;
    userModel.name = _nomController.text;
    userModel.type = "Oui";

    await AuthService().signUpWithEmail(userModel);

    // await firebaseFirestore.collection("utilisateurs").doc(user.uid).set(userModel.toMap());
    Fluttertoast.showToast(msg: "Compte créé avec succès");

  }
}
