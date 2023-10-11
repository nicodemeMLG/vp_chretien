import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:vp_chretien/models/user_model.dart';
import 'package:vp_chretien/pages/my_home_page.dart';
import 'package:vp_chretien/pages/contacts_page.dart';
import 'package:vp_chretien/pages/page_compte/connexion.dart';
import 'package:vp_chretien/pages/profile_page.dart';
import 'package:vp_chretien/pages/programme_lecture.dart';
import 'package:vp_chretien/pages/programme_page.dart';
import 'package:vp_chretien/pages/statistique_page.dart';
import 'package:vp_chretien/services/auth_service.dart';
import 'package:vp_chretien/widgets/appbar_widget.dart';

import '../controlleurs/function_programme.dart';
import '../models/programme_model.dart';

const Color _mainColor= Color(0xFF446600);
class HomePage extends StatefulWidget {
  const HomePage({super.key,});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  DateTime? laDate;
  String annee= DateTime.now().year.toString();
  String mois= DateTime.now().month.toString();
  String jour= DateTime.now().day.toString();

  void _showDatePicker(){
    showDatePicker( initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2025), context: context)
        .then((value){
      laDate=value!;
      setState(() {});
    }
    );
  }

  int _currentIndex = 0;
  int drawerColor=0;
  final auth = FirebaseAuth.instance;

  UserModel userModel = UserModel();
  int a= 0;

  late User user;
  List programmeJour=[];

  void programmeDuJour(String date) async{
    await getProgrammeDuJour(date).then((value){ programmeJour = value;});
  }

  @override
  void initState(){

    user = auth.currentUser as User;
    super.initState();
  }
  String idAnnee="";
  DatabaseReference refannee = FirebaseDatabase.instance.ref();
  void anneeActif() async{
    final snapshot = await refannee.child('Parcours/AnneeActif/id').get();
    String annee=snapshot.value as String;
    idAnnee = annee;
  }

  String cycle="";
  void getCycle() async{
    final ref = FirebaseDatabase.instance.ref().child("actifb");
    final snapshot= await ref.get();
    Map val = snapshot.value as Map;
    cycle = val['actif'];
  }

  String noteParCycle="0";

  void getNoteParCycle() async{
    final refParCycle = FirebaseDatabase.instance.ref().child("lecturesParCycle/$cycle/$idAnnee/${user.uid}");
    refParCycle.onValue.listen((event) {
      if(event.snapshot.value!=null) {
        Map valueCycle =event.snapshot.value as Map;
        noteParCycle = valueCycle['note'];
      }

    });
  }

  void getUser(){
    DatabaseReference ref = FirebaseDatabase.instance.ref().child('Admin/Users/${user.uid}');
    ref.onValue.listen((event) {
      setState(() {
        userModel = UserModel.fromMap(event.snapshot.value);
      });
    });
  }




  Future<List<LectureModel>> getProgrammes() async{
    String cycle="ancien";
    List<LectureModel> programmes=[];
    final ref = FirebaseDatabase.instance.ref().child("actifb");
    await ref.once().then((val) {
      Map value =val.snapshot.value as Map;
      cycle = value['actif'];
    });

    await FirebaseDatabase.instance.ref().child("lecturesParCycle/$cycle/lecture").once()
        .then((event){
      // print(event.snapshot.children);
      for ( var val in event.snapshot.children){
        LectureModel a=LectureModel.fromMap(val.value);
        // print(a.uid);
        programmes.add(a);
      }
      // print(programmes);
    });
    return programmes;
  }

  final PageController _pageController= PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    // final PageController _pageController= PageController(initialPage: _currentIndex);
    String now=DateFormat("dd-MM-yyyy").format(DateTime.now());
    programmeDuJour(now);
    getUser();
    anneeActif();
    getCycle();
    getNoteParCycle();
    Map<String,DateTime?>? date = {'date':laDate};
    List<Widget> tabs =[

      MyHomePage(programmejour: programmeJour,anneeActif:idAnnee),
      StatistiquePage(progression:noteParCycle),
      ProfilePage(userModel: userModel,),
      ProgrammePage(date: date,funcNull:(){
        setState(() {
          laDate=null;
          date=null;
        });
      }),
    ];


    List<Widget> btnActions=[

      IconButton(
          onPressed: (){
            _showDatePicker();
          }, icon: const Icon(Icons.calendar_month_outlined))
    ];

    return Scaffold(
      appBar: _currentIndex==0 ?  const AppBarWidget(title: "VP-CHRETIEN DE BERE",) :
      _currentIndex==1 ? const AppBarWidget(title: "Statistiques",) :
      _currentIndex==2 ? const AppBarWidget(title: "Profile",) :
      _currentIndex==3 ? AppBarWidget(title: "Programme",btnAction: btnActions):
      _currentIndex==4 ? const AppBarWidget(title: "Lecture de la Bible") : AppBar(),
      drawer: Drawer(
        child: ListView(
          children: [
            SizedBox(
              height: 300,
              child: DrawerHeader(
                margin: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: Colors.green[800],
                ),
                child:  Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Column(
                      mainAxisAlignment:MainAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage("images/vp1-bg.png"),
                          width: 250.0,
                          height: 150.0,
                        ),
                        Text("Programme de lecture Biblique",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w800,fontSize: 16 ),),
                        Text("Verts Paturages",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w800,fontSize: 16 ),)
                      ],
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(userModel.name??"", style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 16 ),),
                        Text(userModel.email??"",style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 14 ),),
                      ],
                    )
                  ],
                ),
              ),
            ),

            SizedBox(
              height: 45.0,
              child: ListTile(
                leading: const Icon(Icons.home_filled , size: 20.0, ),
                title: const Text('ACCEUIL',style: TextStyle(
                  fontSize: 15.0,
                ),),
                selectedTileColor: Colors.grey[300],
                selectedColor: _mainColor,
                selected: _currentIndex==0 ?true:false,
                onTap: (){
                  setState(() {
                    _currentIndex = 0;
                    _pageController.jumpToPage(_currentIndex);
                    Navigator.pop(context);

                    // _selected=0;
                  });
                  // Scaffold.of(context).;
                },
              ),
            ),

            const Divider(
              height: 2.0,
            ),
            SizedBox(
              height: 45.0,
              child: ListTile(

                leading: const Icon(Icons.menu_book , size: 20.0, ),
                title: const Text('LECTURE DE LA BIBLE',style: TextStyle(
                  fontSize: 15.0,
                ),),
                selectedTileColor: Colors.grey[300],
                selectedColor: _mainColor,
                // selected: _currentIndex==1?true:false,
                onTap: (){
                  setState(() {
                    Navigator.pop(context);
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const ProgrammeLecture()));
                  });
                },
              ),
            ),

            SizedBox(
              height: 45.0,
              child: ListTile(
                leading: const Icon(Icons.pin_rounded , size: 20.0, ),
                title: const Text('PROGRAMME EN COURS',style: TextStyle(
                  fontSize: 15.0,
                ),),
                selectedTileColor: Colors.grey[300],
                selectedColor: _mainColor,
                selected: _currentIndex==3?true:false,
                onTap: (){
                  setState(() {
                    _currentIndex=3;
                    _pageController.jumpToPage(_currentIndex);
                    Navigator.pop(context);
                  });
                },
              ),
            ),

            const Divider(),

            SizedBox(
              height: 45.0,
              child: ListTile(
                leading: const Icon(Icons.calculate , size: 20.0, ),
                title: const Text('MES STATISTIQUES',style: TextStyle(
                  fontSize: 15.0,
                ),),
                selectedTileColor: Colors.grey[300],
                selectedColor: _mainColor,
                selected: _currentIndex==1?true:false,
                onTap: (){
                  setState(() {
                    _currentIndex=1;
                    _pageController.jumpToPage(_currentIndex);
                    Navigator.pop(context);
                  });
                },
              ),
            ),

            SizedBox(
              height: 45.0,
              child: ListTile(
                leading: const Icon(Icons.person_pin , size: 20.0, ),
                title: const Text('MON PROFIL', style: TextStyle(
                  fontSize: 15.0,
                ),),
                selectedTileColor: Colors.grey[300],
                selectedColor: _mainColor,
                selected: _currentIndex==2?true:false,
                onTap: (){
                  setState(() {
                    _currentIndex=2;
                    _pageController.jumpToPage(_currentIndex);
                    Navigator.pop(context);
                  });
                },
              ),
            ),



            const Divider(),

            SizedBox(
              height: 45.0,
              child: ListTile(
                leading: const Icon(Icons.phone_android_outlined , size: 20.0, ),
                title: const Text('Contacts',style: TextStyle(
                  fontSize: 15.0,
                ),),
                selectedTileColor: Colors.grey[300],
                selectedColor: _mainColor,
                // selected: _selected==5?true:false,
                onTap: (){
                  setState(() {
                    // _selected=5;
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> const ContactsPage()));
                  });
                },
              ),
            ),

            SizedBox(
              height: 45.0,
              child: ListTile(
                leading: const Icon(Icons.logout_rounded , size: 20.0, ),
                title: const Text('Se deconnecter' , style: TextStyle(
                  fontSize: 15.0,
                ),),
                selectedTileColor: Colors.grey[300],
                selectedColor: _mainColor,
                // selected: _selected==6?true:false,
                onTap: (){
                  setState(() {
                    // _selected=6;
                    AuthService().signOut();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const Connexion(actif: false,)));
                  });
                },
              ),
            ),



          ],
        ),
      ),

      body:PageView(
        controller: _pageController,
        onPageChanged: (value){
          setState(() {
            _currentIndex=value;
          });
        },
        children: tabs,
      ) ,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        fixedColor: _mainColor,
        unselectedItemColor: Colors.green[800],
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Acceuil",
          ),

          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.fileInvoice),
            label: "Statistique",
            // backgroundColor: Colors.green,
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
            // backgroundColor: Colors.green,
          ),

          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.ellipsis),
            label: "En cours",
            // backgroundColor: Colors.green,
          ),


        ],

        onTap: (index){
          setState(() {

            _currentIndex = index;

            _pageController.jumpToPage(_currentIndex);
          });
        },
      ),
    );

  }


}