import 'package:flutter/material.dart';
import 'package:vp_chretien/pages/programme_lecture.dart';

const Color _mainColor= Color(0xFF446600);
class ButtonWidget extends StatelessWidget {
  final String titre;
  final VoidCallback? onPressedFunction;

  const ButtonWidget({super.key, required this.titre, required this.onPressedFunction,});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressedFunction,
      style: ElevatedButton.styleFrom(
        backgroundColor: _mainColor,
        fixedSize: const Size(140, 35),
        padding: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(0)),
        ),
      ),

      child: Text(
        titre ,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10.0,
          fontWeight: FontWeight.w600
        ),
      ),
    );
  }
}

