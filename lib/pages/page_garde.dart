// ignore_for_file: deprecated_member_use

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
  void initState() => super.initState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  backgroundColor: Colors.grey[50],
  body: SafeArea(
    child: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo/Image principale
            Hero(
              tag: 'main_image',
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: _mainColor.withOpacity(0.2),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.asset("images/vp1.jpg"),
                ),
              ),
            ),
            
            const SizedBox(height: 20.0),
            
            // Images secondaires
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 90.0,
                  height: 90.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.asset(
                      "images/vp3.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12.0),
                Container(
                  width: 90.0,
                  height: 90.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.asset(
                      "images/vp2.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 40.0),
            
            // État et action
            FutureBuilder(
              future: ProgrammeService().getActifb(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Column(
                    children: [
                      CircularProgressIndicator(
                        color: _mainColor,
                        strokeWidth: 3.0,
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        "Chargement...",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  );
                }
                
                cycle = snapshot.data.toString();
                
                if (cycle == 'clos') {
                  return Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(color: Colors.red.withOpacity(0.2)),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 56.0,
                          height: 56.0,
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.lock_outline,
                            color: Colors.red,
                            size: 28.0,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          "Validations fermées",
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 18.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          "Les validations sont temporairement\nindisponibles. Revenez plus tard.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                
                return Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: ElevatedButton(
                    onPressed: cycle == ""
                        ? null
                        : isLoggedIn()
                            ? () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => const HomePage(),
                                  ),
                                );
                              }
                            : () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const Connexion(actif: false),
                                  ),
                                );
                              },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _mainColor,
                      padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Text(
                      isLoggedIn()
                          ? (cycle == 'ancien'
                              ? "📖 Ancien Testament"
                              : cycle == 'nouveau'
                                  ? "📖 Nouveau Testament"
                                  : "")
                          : "Commencer",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17.0,
                        fontWeight: FontWeight.w600,
                        // letterSpacing: 0.5,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    ),
  ),
);
  }
}
