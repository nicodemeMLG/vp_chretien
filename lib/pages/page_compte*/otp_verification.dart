import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pinput.dart';

import 'package:vp_chretien/pages/page_compte*/inscription_phone_completion.dart';
import 'package:vp_chretien/pages/switch_page.dart';

import '../../controlleurs/function.dart';



Color _mainColor= Color(0xFF446600);


class OtpVerification extends StatefulWidget {
  final String numero;
  final String verificationId;
  const OtpVerification({super.key, required this.numero, required this.verificationId});

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _optController = TextEditingController();

  String smsCode = "";
  bool loading =false;
  bool resend = false;
  int count=20;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    decompte();
  }
  late Timer timer;
  void decompte() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if(count<1){
        timer.cancel();
        count = 40;
        resend=true;
        setState(() {});
        return ;
      }
      count--;
      setState(() {});
    });
  }

  void resendSmsCode() {
    resend=false;
    setState(() {});
    authWithPhoneNumber(
      widget.numero,
      onCodeSend: (verificationId , v){
        loading=false;
        decompte();
        setState(() {});

      },
      onAutoVerify: (v) async{
        loading=false;
        await auth.signInWithCredential(v);
        setState(() {});
      },
      onFailed: (e){
        Fluttertoast.showToast(msg: "le code est erroné");
        print("le code est erroné");
      },
      autoRetrieval: (v){

      },
    );
  }



  void onVerifySmsCode() async {
    loading = true;
    setState(() {});
    await optSend(widget.verificationId, smsCode);
    loading = false;
    setState(() {});
    Fluttertoast.showToast(msg: "Vérification effectué avec succès");

    //on verifie si l'utilisateur a déjà été enregistré sur la real time database
    // si oui, alors on passe sur la page d'acceuil
    // si non on passe sur la page de completion d'informations

    User? user = FirebaseAuth.instance.currentUser;
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('Admin/Users/${user!.uid}').get();
    if(snapshot.value!=null){
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SwitchPage()));
    }else {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => InscriptionPhoneCompletion(numero: widget.numero)));
    }

  }
  @override
  Widget build(BuildContext context) {
    print(widget.verificationId);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(color: Colors.grey.shade600,height: 40.0,),
      ),
      body: WillPopScope(
          child: Container (
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  child: Text(
                    "Entrez le code et cliquez sur vérifier",
                    style: TextStyle(
                      fontSize: 18.0,
                      color: _mainColor,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                SizedBox(
                  child: Text(widget.numero ,
                    style: const TextStyle(
                      fontSize: 18.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Pinput(
                  length: 6,
                  controller: _optController,
                  onChanged: (value){
                    smsCode = value;
                    setState(() {});
                  },

                ),
                const SizedBox(
                  height: 20.0,
                ),

                ElevatedButton(
                  onPressed:  smsCode.length<6 || loading ? null : onVerifySmsCode,
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
                  ) :  const Text("Vérifier" , style: TextStyle( color: Colors.white , fontSize: 20.0, fontWeight: FontWeight.w600),),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                ElevatedButton(
                  onPressed: !resend ? null :resendSmsCode,
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(double.maxFinite, 50.0),
                    backgroundColor: _mainColor,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                    ),
                  ),
                  child: Text( !resend? count.toString() : "Reessayer" , style: const TextStyle( color: Colors.white , fontSize: 20.0, fontWeight: FontWeight.w600),),
                ),

              ],
            ),
          ),
          onWillPop: ()async{
            return false;
          }
      ),
    );
  }



}
