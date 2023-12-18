import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vp_chretien/models/user_model.dart';
import 'package:vp_chretien/pages/home_page.dart';
import 'package:vp_chretien/pages/modifier_informations_page.dart';
import 'package:vp_chretien/pages/page_compte/connexion.dart';
import 'package:vp_chretien/pages/politique_page.dart';
import 'package:vp_chretien/services/auth_service.dart';


// Color _mainColor= const Color(0xFF446600);
class ProfilePage extends StatefulWidget {
  final UserModel userModel;

  const ProfilePage({super.key, required this.userModel});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    final isNotSmallScreen = MediaQuery.of(context).size.width >300;
    return Scaffold(
      // appBar: AppBarWidget(title: "Profile"),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              //const SizedBox(height: 10.0,),

              Image(
                image: const AssetImage("images/profile.png"),
                height:MediaQuery.of(context).size.height * 0.3,
                width: 150,
              ),
              //const SizedBox(height: 10.0,),
              informatioPerso("Nom", widget.userModel.name??""),

              informatioPerso("Contact", widget.userModel.email??""),

              informatioPerso("Téléphone", widget.userModel.mobile??""),

              informatioPerso("Adresse", widget.userModel.locality??""),

              SizedBox(height: isNotSmallScreen?30.0:20.0,),

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

                    child: Text(
                      "RETOUR" ,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: isNotSmallScreen?15.0:11.0,
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

                    child: Text(
                      "MODIFIER" ,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: isNotSmallScreen?15.0:11.0,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                  )
                ],
              ),
              ElevatedButton(
                onPressed: (){
                  AuthService().signOut();
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
                child: Text(
                  "SE DECONNECTER" ,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: isNotSmallScreen?15.0:11.0,
                      fontWeight: FontWeight.w600
                  ),
                ),
              ),


              const SizedBox(height: 30.0,),

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
                          fontSize: isNotSmallScreen?14.0:11.0,
                          fontWeight: FontWeight.w400,

                        ),
                      ),
                    ),

                    TextButton(
                      onPressed: () {
                        Fluttertoast.showToast(msg: "Contact : +226 64-83-86-76");
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,

                      ),
                      child: Text(
                        "Contact du développeur" ,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: isNotSmallScreen?14.0:11.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),

                    TextButton(
                      onPressed: (){
                        AuthService().deleteUser();
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const Connexion(actif: false,)));
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      child: Text(
                        "Supprimer le compte",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: isNotSmallScreen?14.0:11.0,
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

  Widget informatioPerso(String titre, String valeur){
    final isNotSmallScreen = MediaQuery.of(context).size.width >300;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "$titre : ",
          style: TextStyle(
            color: Colors.green[800],
            fontSize: isNotSmallScreen?16.0:11.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        Expanded(
          child: Text(
            valeur,
            maxLines: 3,
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: isNotSmallScreen?16.0:11.0,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),

      ],
    );
  }
}
