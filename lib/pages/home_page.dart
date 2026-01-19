import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
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
    showDatePicker( initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2050), context: context)
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
    try {
      // programmeJour.clear();
      await getProgrammeDuJour(date).then((value){ programmeJour = value;});
    }catch(e){
      debugPrint("Erreur de programme du jour: $e");
    }
  }

  

  
  String idAnnee="";
  DatabaseReference refannee = FirebaseDatabase.instance.ref();
  void anneeActif() async{
    try{

      final snapshot = await refannee.child('Parcours/AnneeActif/id').get();
      String annee=snapshot.value as String;
      idAnnee = annee;
    }catch(e){
      debugPrint("Erreur annee actif: $e");
    }
  }

  String cycle="";
  void getCycle() async{
    try{
      final ref = FirebaseDatabase.instance.ref().child("actifb");
      final snapshot= await ref.get();
      Map val = snapshot.value as Map;
      cycle = val['actif'];
    }catch(e){
      debugPrint("Erreur de cycle: $e");
    }
    
  }

  String noteParCycle="0";

  void getNoteParCycle() async{
    try{

      final refParCycle = FirebaseDatabase.instance.ref().child("lecturesParCycle/$cycle/$idAnnee/${user.uid}");
      refParCycle.onValue.listen((event) {
        if(event.snapshot.value!=null) {
          Map valueCycle =event.snapshot.value as Map;
          noteParCycle = valueCycle['note'];
        }
      });
    } catch(e){
      debugPrint("Erreur note par cycle: $e");
    }
  }

  void getUser(){
    try{

      DatabaseReference ref = FirebaseDatabase.instance.ref().child('Admin/Users/${user.uid}');
      ref.onValue.listen((event) {
        setState(() {
          userModel = UserModel.fromMap(event.snapshot.value);
        });
      });
    } catch(e){
      debugPrint("Erreur de recuperation user: $e");
    }
  }

  Future<List<LectureModel>> getProgrammes() async{
    String cycle="ancien";
    List<LectureModel> programmes=[];
    final ref = FirebaseDatabase.instance.ref().child("actifb");
    await ref.once().then((val) {
      Map value =val.snapshot.value as Map;
      cycle = value['actif'];
    }).catchError(  (error){
      debugPrint("Erreur de recuperation du cycle: $error");
    });

    await FirebaseDatabase.instance.ref().child("lecturesParCycle/$cycle/lectures").once()
        .then((event){
      // print(event.snapshot.children);
      for ( var val in event.snapshot.children){
        LectureModel a=LectureModel.fromMap(val.value);
        // print(a.uid);
        programmes.add(a);
      }
      // print(programmes);
    }).catchError((error){
      debugPrint("Erreur de recuperation des programmes: $error");
    });
    return programmes;
  }

  final PageController _pageController= PageController(initialPage: 0);


  @override
  void initState(){

    user = auth.currentUser as User;
    super.initState();
  }

  @override
  void dispose(){
    refannee;
    _pageController.dispose();
    super.dispose();
  }
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
    // ignore: unused_local_variable
    final isNotSmallScreen = MediaQuery.of(context).size.width >300;
    return Scaffold(
      appBar: _currentIndex==0 ?  const AppBarWidget(title: "VP-CHRETIEN DE BERE",) :
      _currentIndex==1 ? const AppBarWidget(title: "Statistiques",) :
      _currentIndex==2 ? const AppBarWidget(title: "Profile",) :
      _currentIndex==3 ? AppBarWidget(title: "Programme",btnAction: btnActions):
      _currentIndex==4 ? const AppBarWidget(title: "Lecture de la Bible") : AppBar(),
      drawer: Drawer(
  child: Column(
    children: [
      // Header simple
      Container(
        padding: const EdgeInsets.fromLTRB(20.0, 48.0, 20.0, 24.0),
        width: double.infinity,
        color: Colors.green[800],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                "images/vp1-bg.png",
                width: 140,
                height: 70,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              userModel.name ?? "",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              userModel.email ?? "",
              style: TextStyle(
                // ignore: deprecated_member_use
                color: Colors.white.withOpacity(0.8),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
      
      // Menu
      Expanded(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              leading: const Icon(Icons.home_rounded),
              title: const Text('Accueil'),
              selected: _currentIndex == 0,
              // ignore: deprecated_member_use
              selectedTileColor: Colors.green.withOpacity(0.1),
              onTap: () {
                setState(() {
                  _currentIndex = 0;
                  _pageController.jumpToPage(_currentIndex);
                  Navigator.pop(context);
                });
              },
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.menu_book_rounded),
              title: const Text('Lecture de la Bible'),
              onTap: () {
                if (!context.mounted) return;
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ProgrammeLecture(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.track_changes_rounded),
              title: const Text('Programme en cours'),
              selected: _currentIndex == 3,
              // ignore: deprecated_member_use
              selectedTileColor: Colors.green.withOpacity(0.1),
              onTap: () {
                setState(() {
                  _currentIndex = 3;
                  _pageController.jumpToPage(_currentIndex);
                  if (!context.mounted) return;
                  Navigator.pop(context);
                });
              },
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.bar_chart_rounded),
              title: const Text('Mes statistiques'),
              selected: _currentIndex == 1,
              // ignore: deprecated_member_use
              selectedTileColor: Colors.green.withOpacity(0.1),
              onTap: () {
                setState(() {
                  _currentIndex = 1;
                  _pageController.jumpToPage(_currentIndex);
                  if (!context.mounted) return;
                  Navigator.pop(context);
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_rounded),
              title: const Text('Mon profil'),
              selected: _currentIndex == 2,
              // ignore: deprecated_member_use
              selectedTileColor: Colors.green.withOpacity(0.1),
              onTap: () {
                setState(() {
                  _currentIndex = 2;
                  _pageController.jumpToPage(_currentIndex);
                  if (!context.mounted) return;
                  Navigator.pop(context);
                });
              },
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.phone_rounded),
              title: const Text('Contacts'),
              onTap: () {
                if (!context.mounted) return;
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ContactsPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout_rounded, color: Colors.red),
              title: const Text(
                'Se déconnecter',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                AuthService().signOut();
                if (!context.mounted) return;
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const Connexion(actif: false),
                  ),
                );
              },
            ),
          ],
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
        selectedItemColor: _mainColor,
        unselectedItemColor: Colors.grey[400],
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedFontSize: 12.0,
        unselectedFontSize: 11.0,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: "Accueil",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart),
            label: "Statistique",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: "Profil",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            activeIcon: Icon(Icons.menu),
            label: "Programme",
          ),
        ],
        onTap: (index) {
          if (!context.mounted) return;
          setState(() {
            _currentIndex = index;
            _pageController.jumpToPage(_currentIndex);
          });
        },
      )
    );

  }


}