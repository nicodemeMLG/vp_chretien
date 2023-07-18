import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:vp_chretien/pages/MyHomePage.dart';
import 'package:vp_chretien/pages/homePage.dart';
import 'package:vp_chretien/pages/page_compte*/connexion.dart';
import 'package:vp_chretien/pages/page_garde.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,

  );

  FirebaseDatabase.instance.setPersistenceEnabled(true);
  // await initializeDateFormatting('fr_FR',"");
  runApp(const MyApp());


}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      // localizationsDelegates: GlobalMaterialLocalizations.delegates,
      // supportedLocales: const [Locale('fr','FR')],
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: PageGarde(),
    );
  }
}
