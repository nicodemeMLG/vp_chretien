import 'package:flutter/material.dart';
import 'package:vp_chretien/pages/programme.dart';


Color _mainColor= const Color(0xFF446600);
class ProgrammeLecture extends StatelessWidget {
  const ProgrammeLecture({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Lecture de la bible",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 22.0,
            color: _mainColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(

              child: Image(
                image: AssetImage("images/vp1-bg.png"),
                height: 200.0,
                width: 200.0,
              ),
            ),

            const SizedBox(height: 20.0,),

            ElevatedButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return const ProgrammePage2(cycle: 'nouveau');
                }));
              },
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(double.maxFinite, 80.0),
                backgroundColor: _mainColor,
                padding: EdgeInsets.zero,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                ),
              ),
              child: const Text("NOUVEAU TESTAMENT" , style: TextStyle(fontSize: 20.0,color: Colors.white),),
            ),

            const SizedBox(height: 20.0,),

            ElevatedButton(

              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return const ProgrammePage2(cycle: 'ancien');
                }));
              },

              style: ElevatedButton.styleFrom(
                fixedSize: const Size(double.maxFinite, 80.0),
                backgroundColor: _mainColor,
                padding: EdgeInsets.zero,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                ),
              ),
              child: const Text("ANCIEN TESTAMENT" , style: TextStyle(fontSize: 20.0 , color: Colors.white),),
            ),

          ],
        ),
      ),
    );
  }
}
