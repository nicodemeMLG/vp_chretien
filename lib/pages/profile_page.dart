import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vp_chretien/controlleurs/function.dart';
import 'package:vp_chretien/models/user_model.dart';
import 'package:vp_chretien/pages/MyHomePage.dart';
import 'package:vp_chretien/pages/homePage.dart';
import 'package:vp_chretien/pages/modifier_informations_page.dart';
import 'package:vp_chretien/pages/page_compte*/connexion.dart';
import 'package:vp_chretien/pages/politique_page.dart';


// Color _mainColor= const Color(0xFF446600);
class ProfilePage extends StatefulWidget {
  final UserModel userModel;

  const ProfilePage({super.key, required this.userModel});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // final auth= FirebaseAuth.instance;
  // User? user = FirebaseAuth.instance.currentUser;
  // UserModel userModel=UserModel();
  // void initialiseUserModel() async{
  //   User? user = auth.currentUser;
  //   DatabaseReference ref = FirebaseDatabase.instance.ref();
  //   final snapshot = await ref.child('utilisateurs/${user!.uid}').get() ;
  //   userModel = UserModel.fromMap(snapshot.value);
  //
  //
  // }
  // void getUser() async{
  //   await initialiseUserModel().then((value) => user=value).catchError((e)=>Fluttertoast.showToast(msg: "Erreur de connexion"));
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    // DatabaseReference ref = FirebaseDatabase.instance.ref().child('utilisateurs/${user!.uid}');
    // ref.onValue.listen((event) {
    //   setState(() {
    //     userModel = UserModel.fromMap(event.snapshot.value);
    //   });
    //
    // });

    return Scaffold(
      // appBar: AppBarWidget(title: "Profile"),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(height: 20.0,),

              const Image(
                image: AssetImage("images/vp1.jpg"),
                height:100.0,
                width: 150,
              ),
              const SizedBox(height: 30.0,),
              InformatioPerso("Nom", widget.userModel.name??""),

              InformatioPerso("Contact", widget.userModel.email??""),

              InformatioPerso("Téléphone", widget.userModel.mobile??""),

              InformatioPerso("Adresse", widget.userModel.locality??""),

              const SizedBox(height: 40.0,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: (){
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context){
                        return const HomePage();
                      }), (route) => false);
                      // Navigator.
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[800],
                      fixedSize: const Size(140, 35),
                      padding: EdgeInsets.zero,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(0)),
                      ),
                    ),

                    child: const Text(
                      "RETOUR" ,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                  ),

                  ElevatedButton(
                    onPressed: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context){
                        return ModifierInformationsPage(user: widget.userModel,);
                      }));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[800],
                      fixedSize: const Size(140, 35),
                      padding: EdgeInsets.zero,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(0)),
                      ),
                    ),

                    child: const Text(
                      "MODIFIER" ,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                  )
                ],
              ),

              ElevatedButton(
                onPressed: (){
                  signOut();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const Connexion(actif: false,)));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[800],
                  fixedSize: const Size(double.maxFinite, 35),
                  padding: EdgeInsets.zero,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                  ),
                ),
                child: const Text(
                  "SE DECONNECTER" ,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600
                  ),
                ),
              ),

              const SizedBox(height: 40.0,),

              SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextButton(

                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const PolitiquePage()));
                      },
                      style: TextButton.styleFrom(
                          padding: EdgeInsets.zero
                      ),
                      child: Text(
                        "Politique de confidentialité" ,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,

                        ),
                      ),
                    ),

                    TextButton(
                      onPressed: () {
                        Fluttertoast.showToast(msg: "Contact : +2266624512");
                      },
                      style: TextButton.styleFrom(

                        padding: EdgeInsets.zero,

                      ),
                      child: Text(
                        "Contact du développeur" ,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),

                  ],
                ),
              ),


            ],
          ),
        ),

      ),
    );
  }

  Widget InformatioPerso(String titre, String valeur){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "$titre : ",
          style: TextStyle(
            color: Colors.green[800],
            fontSize: 20.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        Expanded(
          child: Text(
            valeur,
            maxLines: 3,
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 18.0,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),

      ],
    );
  }
}
