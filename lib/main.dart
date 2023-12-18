import 'package:flutter/material.dart';
import 'package:flutterproject/screen/absenceScreenEx2.dart';
import 'package:flutterproject/screen/absencescreen.dart';
import 'package:flutterproject/screen/absencescreenEx.dart';
import 'package:flutterproject/screen/matierescreen.dart';

import 'screen/classscreen.dart';
import 'screen/formationscreen.dart';
import 'screen/login.dart';
import 'screen/studentsscreen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(),
      routes: {
        '/login': (context) => Login(),
        '/students': (context) => StudentScreen(),
        '/class': (context) => ClasseScreen(),
        '/matier': (context) => MatiereScreen(),
        '/absences': (context) => AbsenceScreen(),
        '/formation': (context) => FormationScreen(),
        '/absencesEx': (context) => AbsenceScreenEx(),
        '/absencesEx2': (context) => AbsenceScreenEx2(),
      },
    );
  }
}
