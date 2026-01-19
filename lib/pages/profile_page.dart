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
  void initState() => super.initState();

  @override 
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final isNotSmallScreen = MediaQuery.of(context).size.width >300;
    Widget buildFooterLink({
      required IconData icon,
      required String text,
      required VoidCallback onTap,
      bool isDestructive = false,
    }) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          child: Row(
            children: [
              Icon(
                icon,
                size: 18.0,
                color: isDestructive ? Colors.red[400] : Colors.grey[600],
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    color: isDestructive ? Colors.red[400] : Colors.grey[700],
                    fontSize: isNotSmallScreen ? 14.0 : 11.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 18.0,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 20.0),
                
                // Avatar avec cercle
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20.0),
                  child: Image.asset(
                    "images/profile.png",
                    fit: BoxFit.contain,
                  ),
                ),
                
                const SizedBox(height: 32.0),
                
                // Informations personnelles
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      informatioPerso("Nom", widget.userModel.name ?? ""),
                      const Divider(height: 24.0),
                      informatioPerso("Contact", widget.userModel.email ?? ""),
                      const Divider(height: 24.0),
                      informatioPerso("Téléphone", widget.userModel.mobile ?? ""),
                      const Divider(height: 24.0),
                      informatioPerso("Adresse", widget.userModel.locality ?? ""),
                    ],
                  ),
                ),
                
                SizedBox(height: isNotSmallScreen ? 32.0 : 24.0),
                
                // Boutons d'action
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // if (!context.mounted) return;
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) {
                              return const HomePage();
                            }),
                            (route) => false,
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.green[800],
                          side: BorderSide(color: Colors.green[800]!, width: 1.5),
                          padding: const EdgeInsets.symmetric(vertical: 14.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        icon: const Icon(Icons.arrow_back, size: 18.0),
                        label: Text(
                          "Retour",
                          style: TextStyle(
                            fontSize: isNotSmallScreen ? 14.0 : 11.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (!context.mounted) return;
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) {
                              return ModifierInformationsPage(
                                user: widget.userModel,
                              );
                            }),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[800],
                          padding: const EdgeInsets.symmetric(vertical: 14.0),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        icon: const Icon(Icons.edit, size: 18.0,color: Colors.white,),
                        label: Text(
                          "Modifier",
                          style: TextStyle(
                            fontSize: isNotSmallScreen ? 14.0 : 11.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12.0),
                
                // Bouton déconnexion
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      AuthService().signOut();
                      if (!context.mounted) return;
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const Connexion(actif: false),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red, width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    icon: const Icon(Icons.logout, size: 18.0),
                    label: Text(
                      "Se déconnecter",
                      style: TextStyle(
                        fontSize: isNotSmallScreen ? 14.0 : 11.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 40.0),
                
                // Liens footer
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      buildFooterLink(
                        icon: Icons.privacy_tip_outlined,
                        text: "Politique de confidentialité",
                        onTap: () {
                          if (!context.mounted) return;
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const PolitiquePage(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12.0),
                      buildFooterLink(
                        icon: Icons.phone_outlined,
                        text: "Contact du développeur",
                        onTap: () {
                          Fluttertoast.showToast(
                            msg: "Contact : +226 64-83-86-76",
                          );
                        },
                      ),
                      const SizedBox(height: 12.0),
                      buildFooterLink(
                        icon: Icons.delete_outline,
                        text: "Supprimer le compte",
                        onTap: () {
                          AuthService().deleteUser();
                          if (!context.mounted) return;
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const Connexion(actif: false),
                            ),
                          );
                        },
                        isDestructive: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );


  }
// Widget helper pour les liens footer

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
