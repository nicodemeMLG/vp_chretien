
import 'package:flutter/material.dart';
import 'package:vp_chretien/services/auth_service.dart';

import '../pages/page_compte/connexion.dart';
const Color _mainColor= Color(0xFF446600);
class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {


  final String title;
  final List<Widget>? btnAction;
  
  @override
  Size get preferredSize{
    return const Size.fromHeight(50.0);
  }

  const AppBarWidget({super.key, required this.title, this.btnAction});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(onPressed: (){
        Scaffold.of(context).openDrawer();
      }, icon: Icon(Icons.menu, color: Colors.grey[600])),
      backgroundColor: Colors.white,
      title: Text(
        title,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 20.0,
          color: _mainColor,
        ),
      ),

      actions: [

        Row(
          children: btnAction != null ? btnAction!.map((e) => e).toList(): [],
        ),

        PopupMenuButton<String>(
          padding: const EdgeInsets.all(0.0),
          surfaceTintColor: Colors.grey[100],
          color: Colors.white,
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              padding: const EdgeInsets.all(4.0),
              value: 'deconnexion',
              child: Text('Déconnexion' , style: TextStyle( fontSize: 18.0, color: Colors.grey.shade700,),),
            ),

          ],
          onSelected: (String value) {
            if(value=='deconnexion'){
              AuthService().signOut();
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const Connexion(actif: false,)));
            }
          },
          icon: Icon(Icons.more_vert, color: Colors.grey[600]) , // Icône des trois points verticaux
        )
      ],
    );
  }
}
