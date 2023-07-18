import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vp_chretien/models/programme_model.dart';
import 'package:vp_chretien/widgets/contenu_widget.dart';
import 'package:vp_chretien/widgets/validation_contenu_widget.dart';


Color _mainColor= const Color(0xFF446600);

class LecturePage extends StatefulWidget {
  final ProgrammeModel element;
  final bool disponible;
  final bool isValid;
  const LecturePage({super.key, required this.element, required this.disponible, required this.isValid});
  @override
  State<LecturePage> createState() => _LecturePageState();
}

class _LecturePageState extends State<LecturePage> {
  DateFormat format = DateFormat('d-M-y');



  @override
  Widget build(BuildContext context) {

    DateTime date = format.parse(widget.element.disponible.toString());
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.element.livrename.toString()??"",overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white , fontSize: 20.0 , fontWeight: FontWeight.w800),),
        backgroundColor: _mainColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Container(
                width: double.maxFinite,
                height: 40.0,
                padding: const EdgeInsets.only(left: 5.0 , top: 4.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue,width: 2.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(widget.element.livrename.toString()??"",overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey[800] , fontSize: 18.0,fontWeight: FontWeight.w500),),
              ),
              widget.disponible ? ContenuWidget(element:widget.element, isValid: widget.isValid, ) : ValidationContenuWidget(dateValid: date),
            ],
          ),
        ),
      ),
    );
  }
}


