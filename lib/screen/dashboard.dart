import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutterproject/template/navbar.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar('Dashboard'),
      backgroundColor: const Color.fromARGB(
          255, 255, 68, 183), // Change the background color
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(
                    255, 255, 68, 224), // Change the header background color
              ),
              child: Text(
                'Navigation',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Etudiant'),
              onTap: () {
                Navigator.pushNamed(context, '/students');
              },
            ),
            ListTile(
              title: const Text('Classes'),
              onTap: () {
                Navigator.pushNamed(context, '/class');
              },
            ),
            ListTile(
              title: const Text('Matiers'),
              onTap: () {
                Navigator.pushNamed(context, '/matier');
              },
            ),
            ListTile(
              title: const Text('Absences'),
              onTap: () {
                Navigator.pushNamed(context, '/absences');
              },
            ),
            ListTile(
              title: const Text('Formations'),
              onTap: () {
                Navigator.pushNamed(context, '/formation');
              },
            ),
            ListTile(
              title: const Text('AbscenceEx'),
              onTap: () {
                Navigator.pushNamed(context, '/absencesEx');
              },
            ),
            ListTile(
              title: const Text('AbscenceEx2'),
              onTap: () {
                Navigator.pushNamed(context, '/absencesEx2');
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Hello world',
              style: TextStyle(
                fontSize: 30.0,
                fontFamily: 'Agne',
                color: Colors.white, // Change the text color
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
