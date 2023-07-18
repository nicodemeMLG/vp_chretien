import 'package:flutter/material.dart';
import 'package:vp_chretien/pages/MyHomePage.dart';

class DrawerWidget extends StatefulWidget {

  final int  indexPage;
  const DrawerWidget({super.key, required this.indexPage});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.indexPage;
  }
  int _selected = 0;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          SizedBox(
            height: 300,
            child: DrawerHeader(
              margin: EdgeInsets.zero,
              decoration: BoxDecoration(
                  color: Colors.green
              ),
              child: Container(
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(


                      children: [
                        Image(
                          image: AssetImage("images/5.jpg"),
                          width: 150.0,
                          height: 150.0,
                        ),
                        Text("Programme de lecture Biblique",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w800,fontSize: 16 ),),
                        Text("Verts Paturages",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w800,fontSize: 16 ),)
                      ],
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Aïcha Ouedraogo épse Dipama", style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 16 ),),
                        Text("aichajuniore@gmail.com",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 14 ),),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),

          Container(
            height: 45.0,
            child: ListTile(
              leading: const Icon(Icons.home_filled , size: 20.0, ),
              title: const Text('ACCEUIL',style: TextStyle(
                fontSize: 15.0,
              ),),
              selectedTileColor: Colors.grey[300],
              selectedColor: Colors.green,
              selected: _selected==0?true:false,
              onTap: (){
                setState(() {
                  // widget.indexPage = 0;
                  _selected=0;
                  Navigator.of(context).push(MaterialPageRoute(builder: (context){
                    return MyHomePage(programmejour: [],);
                  }));
                });
              },
            ),
          ),

          Divider(
            height: 2.0,
          ),
          Container(
            height: 45.0,
            child: ListTile(

              leading: Icon(Icons.menu_book , size: 20.0, ),
              title: Text('LECTURE DE LA BIBLE',style: TextStyle(
                fontSize: 15.0,
              ),),
              selectedTileColor: Colors.grey[300],
              selectedColor: Colors.green,
              selected: _selected==1?true:false,
              onTap: (){
                setState(() {
                  _selected=1;
                });
              },
            ),
          ),


          Container(
            height: 45.0,
            child: ListTile(
              leading: Icon(Icons.pin_rounded , size: 20.0, ),
              title: Text('PROGRAMME EN COURS',style: TextStyle(
                fontSize: 15.0,
              ),),
              selectedTileColor: Colors.grey[300],
              selectedColor: Colors.green,
              selected: _selected==2?true:false,
              onTap: (){
                setState(() {
                  _selected=2;
                });
              },
            ),
          ),



          Divider(),

          Container(
            height: 45.0,
            child: ListTile(
              leading: Icon(Icons.calculate , size: 20.0, ),
              title: Text('MES STATISTIQUES',style: TextStyle(
                fontSize: 15.0,
              ),),
              selectedTileColor: Colors.grey[300],
              selectedColor: Colors.green,
              selected: _selected==3?true:false,
              onTap: (){
                setState(() {
                  _selected=3;
                });
              },
            ),
          ),

          Container(
            height: 45.0,
            child: ListTile(
              leading: Icon(Icons.person_pin , size: 20.0, ),
              title: Text('MON PROFIL', style: TextStyle(
                fontSize: 15.0,
              ),),
              selectedTileColor: Colors.grey[300],
              selectedColor: Colors.green,
              selected: _selected==4?true:false,
              onTap: (){
                setState(() {
                  _selected=4;
                });
              },
            ),
          ),



          Divider(),

          Container(
            height: 45.0,
            child: ListTile(
              leading: Icon(Icons.phone_android_outlined , size: 20.0, ),
              title: Text('Contacts',style: TextStyle(
                fontSize: 15.0,
              ),),
              selectedTileColor: Colors.grey[300],
              selectedColor: Colors.green,
              selected: _selected==5?true:false,
              onTap: (){
                setState(() {
                  _selected=5;
                });
              },
            ),
          ),

          Container(
            height: 45.0,
            child: ListTile(
              leading: Icon(Icons.logout_rounded , size: 20.0, ),
              title: Text('Se deconnecter' , style: TextStyle(
                fontSize: 15.0,
              ),),
              selectedTileColor: Colors.grey[300],
              selectedColor: Colors.green,
              selected: _selected==6?true:false,
              onTap: (){
                setState(() {
                  _selected=6;
                });
              },
            ),
          ),



        ],
      ),
    );
  }
}
