// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../pages/moyenne_quiz_page.dart';


Color mainColor= const Color(0xFF446600);
class ListeQuizWidget extends StatelessWidget {
  final String element;
  final String idAnnee;
  const ListeQuizWidget({super.key, required this.element, required this.idAnnee});

  @override
  Widget build(BuildContext context) {
    final isNotSmallScreen = MediaQuery.of(context).size.width >300;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.25),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MoyenneQuizPage(
                  quiz: element,
                  idAnnee: idAnnee,
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(10.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
            child: Row(
              children: [
                // Icône
                Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const Icon(
                    Icons.lightbulb_outline,
                    size: 22.0,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(width: 12.0),

                // Titre
                Expanded(
                  child: Text(
                    element,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                const SizedBox(width: 8.0),

                // Bouton avec icône
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MoyenneQuizPage(
                          quiz: element,
                          idAnnee: idAnnee,
                        ),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: isNotSmallScreen ? 12.0 : 8.0,
                      vertical: 8.0,
                    ),
                  ),
                  icon: Icon(
                    Icons.bar_chart,
                    size: isNotSmallScreen ? 16.0 : 14.0,
                  ),
                  label: Text(
                    "Moyenne",
                    style: TextStyle(
                      fontSize: isNotSmallScreen ? 13.0 : 10.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
