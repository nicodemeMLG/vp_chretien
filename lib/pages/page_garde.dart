import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:vp_chretien/pages/home_page.dart';
import 'package:vp_chretien/pages/page_compte/connexion.dart';
import 'package:vp_chretien/services/programme_service.dart';


Color _mainColor= const Color(0xFF446600);

class PageGarde extends StatefulWidget {
  const PageGarde({super.key});
  @override
  State<PageGarde> createState() => _PageGardeState();
}

class _PageGardeState extends State<PageGarde> {
  final _auth = FirebaseAuth.instance;

  bool isLoggedIn(){
    return _auth.currentUser != null ? true : false;
  }

  String cycle="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(image: AssetImage("images/vp1.jpg")),
            const SizedBox(height: 10.0,),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                    image: AssetImage("images/vp3.jpg"),
                  width: 100.0,
                ),
                SizedBox(width: 10.0,),
                Image(
                    image: AssetImage("images/vp2.jpg"),
                  width: 100.0,
                  height: 100.0,
                ),
              ],
            ),
            const SizedBox(height: 20.0,),
            FutureBuilder(
              future: ProgrammeService().getActifb(),
              builder: (context , snapshot){
                if(snapshot.connectionState==ConnectionState.waiting){
                  return const CircularProgressIndicator(color: Colors.green,);
                }else{
                  cycle = snapshot.data.toString();
                  return cycle=='clos'? Text("LES VALIDATIONS SONT FERMEES POUR L'INSTANT !",style: TextStyle(
                    color: Colors.red,
                    fontSize: MediaQuery.of(context).size.width >300? 16 : 11,
                  ),) : ElevatedButton(
                    onPressed: cycle==""?null: isLoggedIn()? (){
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const HomePage()));
                    } : (){
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const Connexion(actif: false,)));
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(200.0, 50.0),
                      backgroundColor: _mainColor,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(0)),
                      ),
                      padding: const EdgeInsets.all(5.0),
                    ),
                    child: isLoggedIn() ? Text(cycle=='ancien'?"Ancien Testament":cycle=='nouveau'?"Nouveau Testament":"", style: TextStyle( color: Colors.white , fontSize: MediaQuery.of(context).size.width >300? 18 : 12, fontWeight: FontWeight.w600),) :
                    const Text( "Connexion", style: TextStyle(color: Colors.white , fontSize: 20.0, fontWeight: FontWeight.w600),) ,
                  ) ;
                }
              }
            ),

          ],
        ),
      ),
    );
  }
}
