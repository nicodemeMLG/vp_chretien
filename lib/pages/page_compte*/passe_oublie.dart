import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vp_chretien/controlleurs/function.dart';

const Color _mainColor= Color(0xFF446600);
class PasseOublie extends StatefulWidget {
  const PasseOublie({super.key});

  @override
  State<PasseOublie> createState() => _PasseOublieState();
}

class _PasseOublieState extends State<PasseOublie> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool loading = false;



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
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: Colors.blue,
                    controller: _emailController,
                    style: const TextStyle(
                        fontSize: 18.0
                    ),
                    decoration: InputDecoration(
                      focusColor: Colors.blue,

                      hintText: "Email",
                      labelStyle: TextStyle(color: Colors.grey.shade500,fontSize: 18.0),
                      enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          borderSide: BorderSide(color: _mainColor,width: 2.0)
                      ),
                      focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          borderSide: BorderSide(color: _mainColor,width: 2.0)
                      ),
                    ),
                    validator: (valeur){
                      if(valeur==null || valeur.isEmpty){
                        return "Veuillez saisir une adresse email";
                      }
                      return null;

                    },
                  ),
                ),
                const SizedBox(height: 25.0,),

                ElevatedButton(
                  onPressed: loading? null : () async{
                    if(_formKey.currentState!.validate()){
                      loading=true;
                      setState(() {});
                      bool send = await resetPassword(_emailController.text);
                      if(send){
                        Fluttertoast.showToast(msg: "Accédez à votre email pour modifier le mot de passe");
                      }else{
                        Fluttertoast.showToast(msg: "Une erreur s'est produite, veuillez réessayer plus tard");
                      }
                      Navigator.of(context).pop();
                    }
                  },

                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(double.maxFinite, 50.0),
                    backgroundColor: _mainColor,
                    shape: const RoundedRectangleBorder(

                      borderRadius: BorderRadius.all(Radius.circular(25)),
                    ),
                  ),
                  child: loading?
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ) :  const Text("réinitiamiser le mot de passe" , style: TextStyle( color: Colors.white , fontSize: 20.0, fontWeight: FontWeight.w600),),
                ),
                const SizedBox(height: 5.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                      child: const Text("<<Retour" , style: TextStyle( color: _mainColor , fontSize: 15.0, fontWeight: FontWeight.normal),),
                    ),

                  ],
                ),

                const SizedBox(height: 25.0,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
