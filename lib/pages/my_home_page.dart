import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vp_chretien/pages/lectures_non_valides_page.dart';
import 'package:vp_chretien/pages/lectures_valides_page.dart';
import 'package:vp_chretien/widgets/date_widget.dart';
import 'package:vp_chretien/widgets/liste_programme_jour_widget.dart';
import 'package:vp_chretien/widgets/slider_widget.dart';

Color mainColor= const Color(0xFF446600);

class MyHomePage extends StatefulWidget{
  final List programmejour;
  final String? anneeActif;
  const MyHomePage({super.key, required this.programmejour, this.anneeActif});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final String? userId=FirebaseAuth.instance.currentUser?.uid;
  
  late String cycle;
  late String noteParCycle;
  late String noteParDate;
  String date=DateFormat("dd-MM-yyyy").format(DateTime.now());
  List sliderModel=[];
  void getCycle() async{
    final ref = FirebaseDatabase.instance.ref().child("actifb");
    final snapshot= await ref.get();
    Map val = snapshot.value as Map;
    cycle = val['actif'];
  }

  void getNoteParDate() async{
    final refParDate = FirebaseDatabase.instance.ref().child("lecturesParDate/$date/${widget.anneeActif}/$cycle/$userId");
    final snapshot = await refParDate.get();
    Map? valueDate = snapshot.value!=null ? snapshot.value as Map : {};
    noteParDate= valueDate['note']??"0";
  }

  void getSliderImage() async{
    final ref = FirebaseDatabase.instance.ref().child("SliderModel1");
    final snapshot = await ref.get();
    for (var slide in snapshot.children){
      Map s = slide.value as Map;
      sliderModel.add(s['banner']);
    }

  }

  void getNoteParCycle() async{
    final refParCycle = FirebaseDatabase.instance.ref().child("lecturesParCycle/$cycle/${widget.anneeActif}/$userId");
    refParCycle.onValue.listen((event) {
      if(event.snapshot.value!=null) {
        Map valueCycle =event.snapshot.value as Map;
        noteParCycle = valueCycle['note'];
      }else{
        noteParDate="0";
      }

    });
  }
  @override
  void initState(){
    super.initState();
    cycle="";
    noteParCycle="0";
    noteParDate="0";
  }

  @override
  void dispose(){
    
    sliderModel.clear();
    super.dispose();
  } 

  

  @override
  Widget build(BuildContext context){
    getCycle();
    getSliderImage();
    getNoteParCycle();
    getNoteParDate();

    final isNotSmallScreen = MediaQuery.of(context).size.width >300;
    return Scaffold(
  body: Container(
    color: mainColor,
    height: double.infinity,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5.0),
        const DateWidget(),
        
        // Carte principale avec les informations du cycle
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8.0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Slider
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
                child: SliderWidget(stockImg: sliderModel),
              ),
              
              // Informations du cycle
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badge du testament
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 6.0,
                      ),
                      decoration: BoxDecoration(
                        // ignore: deprecated_member_use
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(color: Colors.green, width: 1.5),
                      ),
                      child: Text(
                        cycle == "ancien" 
                            ? "ANCIEN TESTAMENT" 
                            : "NOUVEAU TESTAMENT",
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: isNotSmallScreen ? 14.0 : 10.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 12.0),
                    
                    // Progression avec barre
                    Row(
                      children: [
                        Icon(
                          Icons.trending_up,
                          color: Colors.green,
                          size: isNotSmallScreen ? 20.0 : 16.0,
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          "Progression générale: ",
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: isNotSmallScreen ? 14.0 : 10.0,
                          ),
                        ),
                        Text(
                          "$noteParCycle%",
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: isNotSmallScreen ? 16.0 : 11.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 8.0),
                    
                    // Barre de progression
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: LinearProgressIndicator(
                        value: double.parse(noteParCycle) /100,
                        minHeight: 8.0,
                        backgroundColor: Colors.grey[200],
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.green,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16.0),
                    
                    // Boutons d'action
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => LecturesValidesPage(
                                    idAnnee: widget.anneeActif,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: 8.0,
                              ),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: const BorderSide(
                                  color: Colors.green,
                                  width: 1.5,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    size: 18.0,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                Flexible(
                                  child: Text(
                                    "Lectures validées",
                                    overflow: TextOverflow.ellipsis,
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
                        
                        const SizedBox(width: 10.0),
                        
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => LecturesNonValidesPage(
                                    anneeActif: widget.anneeActif,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: 8.0,
                              ),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: const BorderSide(
                                  color: Colors.red,
                                  width: 1.5,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: const Icon(
                                    Icons.clear,
                                    size: 18.0,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                Flexible(
                                  child: Text(
                                    "Lectures non validées",
                                    overflow: TextOverflow.ellipsis,
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
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        // Programme du jour
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
          child: Row(
            children: [
              Icon(
                Icons.calendar_today,
                color: Colors.white,
                size: isNotSmallScreen ? 18.0 : 14.0,
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  "Programme du jour: $noteParDate% ($cycle test.)",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: isNotSmallScreen ? 15.0 : 11.0,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Liste des lectures
        widget.programmejour.isNotEmpty
            ? Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ProgrammeSection(
                    element: widget.programmejour,
                    anneeActif: widget.anneeActif.toString(),
                  ),
                ),
              )
            : Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.book_outlined,
                        size: 64.0,
                        // ignore: deprecated_member_use
                        color: Colors.white.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        "Pas de lectures pour aujourd'hui!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isNotSmallScreen ? 16.0 : 14.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ],
    ),
  ),
);
  }
}

class ProgrammeSection extends StatelessWidget{
  final List element;
  final String anneeActif;
  const ProgrammeSection({super.key, required this.element, required this.anneeActif});
  @override
  Widget build(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: element.map((e){
        return ListeProgrammeJourWidget(element: e,anneeActif:anneeActif);
      }).toList(),
    );
  }
}