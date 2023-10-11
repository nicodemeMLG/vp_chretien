import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:vp_chretien/pages/home_page.dart';

Color _mainColor= const Color(0xFF446600);
class QuizPage extends StatefulWidget {
  final String? nomQuiz;
  const QuizPage({super.key, this.nomQuiz});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List questions=[];
  
  Future<List> getQuestions() async{
    List questions=[];
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('tests/${widget.nomQuiz}/Questions').get();
    for(var q in snapshot.children){
      Map quiz = q.value as Map;
      questions.add(quiz);
    }
    return questions;
  }

  @override
  Widget build(BuildContext context) {
    int note = 0;
    int compte=0;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Quiz",overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white , fontSize: 20.0 , fontWeight: FontWeight.w800),),
        backgroundColor: _mainColor,
      ),
      body: SizedBox(
        height: double.maxFinite,
        width: double.maxFinite,
        child: FutureBuilder(
          future: getQuestions(),
          builder: (context, snapshot){
            if(snapshot.connectionState==ConnectionState.waiting){
              return const Center(
                child: CircularProgressIndicator(color: Colors.green,),
              );
            }
            else if(snapshot.hasData){
              questions=snapshot.data as List;

              return SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 15.0,),
                    Text(widget.nomQuiz??"" , style: TextStyle(color: Colors.grey.shade800 , fontSize: 20.0, fontWeight: FontWeight.w700 )),
                    const SizedBox(height: 15.0,),
                    Column(
                      children: questions.map((question){
                        compte++;
                        question['reponse']=false;
                        return ChoiceBox(question: question, count: compte,);
                      }).toList(),
                    ),
                    const SizedBox(height: 10.0,),
                    ElevatedButton(
                      onPressed: (){
                        for(var q in questions){
                          if(q['reponse']==true){
                            note+=10;
                          }
                        }
                        enrregistrerResult(widget.nomQuiz , note);
                        showAlertDialog(context, note.toStringAsFixed(2));
                    },
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          side: BorderSide(),
                        ),
                      ),
                      child:const Text("Valider"),
                    ),
                  ],
                ),
              );
            }
            else{
              return const SizedBox();
            }
          },
        ),
      ),

    );
  }
}

class ChoiceBox extends StatefulWidget {
  final Map question;
  final int count;
  const ChoiceBox({super.key, required this.question, required this.count});

  @override
  State<ChoiceBox> createState() => _ChoiceBoxState();
}

class _ChoiceBoxState extends State<ChoiceBox> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Text("${widget.count} ${widget.question['question']}" , style: const TextStyle(color: Colors.deepPurple , fontSize: 18.0,fontWeight: FontWeight.w700 ),),
          widget.question['opt_A']!="null"?
          ListTile(
            title: Text(widget.question['opt_A'],style: TextStyle(color: Colors.grey.shade800 , fontSize: 15.0 )),
            leading: Radio(
              value: 'A', groupValue: widget.question['value'],
              onChanged: (value) {
                setState(() {
                  widget.question['value']=value;
                  if(widget.question['value']==widget.question['answer']){
                    widget.question['reponse']=true;
                  } else{
                    widget.question['reponse']=false;
                  }

                });

              },

            ),
          ):const SizedBox(),
          widget.question['opt_B']!="null"?
          ListTile(
            title: Text(widget.question['opt_B'],style: TextStyle(color: Colors.grey.shade800 , fontSize: 15.0 )),
            leading: Radio(
              value: 'B', groupValue: widget.question['value'],
              onChanged: (value) {
                setState(() {
                  widget.question['value']=value;
                  if(widget.question['value']==widget.question['answer']){
                    widget.question['reponse']=true;
                  } else{
                    widget.question['reponse']=false;
                  }
                });

              },

            ),
          ):const SizedBox(),
          widget.question['opt_C']!="null"?
          ListTile(
            title: Text(widget.question['opt_C'],style: TextStyle(color: Colors.grey.shade800 , fontSize: 15.0 )),
            leading: Radio(
              value: 'C', groupValue: widget.question['value'],
              onChanged: (value) {
                setState(() {
                  widget.question['value']=value;
                  if(widget.question['value']==widget.question['answer']){
                    widget.question['reponse']=true;
                  } else{
                    widget.question['reponse']=false;
                  }
                });

              },

            ),
          ) : const SizedBox(),
          widget.question['opt_D']!="null"?
          ListTile(
            title: Text(widget.question['opt_D'],style: TextStyle(color: Colors.grey.shade800 , fontSize: 15.0 )),
            leading: Radio(
              value: 'D', groupValue: widget.question['value'],
              onChanged: (value) {
                setState(() {
                  widget.question['value']=value;
                  if(widget.question['value']==widget.question['answer']){
                    widget.question['reponse']=true;
                  } else{
                    widget.question['reponse']=false;
                  }
                });

              },

            ),
          ) : const SizedBox(),

          ListTile(
            title: Text("Effacer mon choix",style: TextStyle(color: Colors.grey.shade800 , fontSize: 15.0 )),
            leading: Radio(
              value: '', groupValue: widget.question['value'],
              onChanged: (value) {
                setState(() {
                  widget.question['value']=null;

                });

              },

            ),
          ),
        ],
      ),
    );
  }
}
void enrregistrerResult(String? intitule , int note) async{
  final ref = FirebaseDatabase.instance.ref();
  String userId= FirebaseAuth.instance.currentUser!.uid;
  final snapshot1 = await ref.child("Admin/Users/$userId/name").get();
  String nomUser = snapshot1.value as String;
  
  final snapshot2 = await ref.child("Parcours/AnneeActif/id").get();
  String anneeActif = snapshot2.value as String;

  Map result = {
    'name':nomUser,
    'note': "$note",
    'uid':userId,
  };
   await ref.child("Results/$intitule/$anneeActif/$userId").set(result);
}

void showAlertDialog(BuildContext context,String note) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Note du quiz',style: TextStyle(
          color: Colors.deepPurple,
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
        ),),
        content: Text('Vous avez obtenu la note de: $note% !',textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Fermer'),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context){return const HomePage();}), (route) => false); // Ferme la boîte de dialogue
            },
          ),

        ],
      );
    },
  );
}


