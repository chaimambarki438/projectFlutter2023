import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutterproject/screen/studentsscreen.dart';
import 'package:http/http.dart' as http;
import 'package:flutterproject/entities/absence.dart';
import 'package:flutterproject/entities/student.dart';
import 'package:flutterproject/entities/matier.dart';
import 'package:flutterproject/template/dialog/absencedialog.dart';
import 'package:flutterproject/template/navbar.dart';
import 'package:http/http.dart';
import 'dart:convert';
import '../entities/classe.dart';

class AbsenceScreenEx2 extends StatefulWidget {
  @override
  AbsenceScreenState createState() => AbsenceScreenState();
}

class AbsenceScreenState extends State<AbsenceScreenEx2> {
  List<Classe> classes = [];
  List<Student> students = [];
  Classe? selectedClass;
  Student? selectedStudent;
  Matier? selectedMatiere;
  List<Absence>? absences;
  String? selectedDate;

  @override
  void initState() {
    super.initState();
    getAllClasses().then((result) {
      setState(() {
        classes = result;
      });
      print("class from absencescreen: " +
          classes.elementAt(0).matieres.toString());
    });
  }

  refresh() {
    setState(() {});
  }

  Future<void> getAbsenceByMatiereAndDate(
    Matier selectedMatiere,
    String selectedDate,
  ) async {
    try {
      Response response = await http.get(
        Uri.parse(
          "http://10.0.2.2:8080/absence/getByMatiereIdAndDate"
          "?matiereId=${selectedMatiere.matiereId}"
          "&date=$selectedDate",
        ),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<Absence> matiereAbsences =
            data.map((json) => Absence.fromJson(json)).toList();
        setState(() {
          absences = matiereAbsences;
        });
      } else {
        throw Exception("Failed to load absences");
      }
    } catch (e) {
      print("Error in getAbsenceByMatiereAndDate: $e");
    }
  }

  Future<void> getStudentsByClass(Classe selectedClass) async {
    try {
      Response response = await http.get(
        Uri.parse(
            "http://10.0.2.2:8080/etudiant/getByClasseId/${selectedClass.codClass}"),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<Student> studentsInClass =
            data.map((json) => Student.fromJson(json)).toList();
        setState(() {
          students = studentsInClass;
        });
      } else {
        throw Exception("Failed to load students");
      }
    } catch (e) {
      print("Error in getStudentsByClass: $e");
    }
  }

  Future<void> getAbsenceByStudentId() async {
    try {
      Response response = await http.get(Uri.parse(
          "http://10.0.2.2:8080/absence/getByEtudiantId/${this.selectedStudent?.id}"));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<Absence> studentAbcenses =
            data.map((json) => Absence.fromJson(json)).toList();
        setState(() {
          absences = studentAbcenses;
        });
      } else {
        throw Exception("Failed to load absences");
      }
    } catch (e) {
      print("Error in getAbsenceByStudentId: $e");
    }
  }

  Future<void> getByMatiereIdAndDateTotal(
    Matier selectedMatiere,
    String selectedDate,
  ) async {
    try {
      Response response = await http.get(
        Uri.parse(
          "http://10.0.2.2:8080/absence/getByMatiereIdAndDateTotal"
          "?matiereId=${selectedMatiere.matiereId}&date=$selectedDate",
        ),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic>? data = jsonDecode(response.body);

        if (data != null && data is Map<String, dynamic>) {
          print("Received data: $data");

          // Extracting total hours for each student
          Map<String, dynamic>? etudiantTotalHoursMap =
              data['etudiantTotalHours'];
          if (etudiantTotalHoursMap != null &&
              etudiantTotalHoursMap is Map<String, dynamic>) {
            Map<int, double> etudiantTotalHours = etudiantTotalHoursMap.map(
                (key, value) => MapEntry(int.parse(key), value.toDouble()));
            print(etudiantTotalHours);
          }

          // Extracting absences
          List<Absence>? matiereDateAbsences = (data['absences'] as List?)
              ?.map((json) => Absence.fromJson(json))
              .toList();

          setState(() {
            this.absences = matiereDateAbsences;
            // You can also handle totalAbsences as needed
          });
        } else {
          throw Exception("Response data is not of the expected format");
        }
      } else {
        throw Exception(
            "Failed to load data. Status code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error in getByMatiereIdAndDateTotal: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar('AbsencesEx2'),
      body: Column(
        children: [
          DropdownButtonFormField<Classe>(
            value: selectedClass,
            onChanged: (Classe? value) {
              setState(() {
                selectedStudent = null;
                absences = null;
                selectedClass = value;
                if (selectedClass != null) {
                  getStudentsByClass(selectedClass!);
                }
              });
            },
            items: classes.map((Classe classe) {
              return DropdownMenuItem<Classe>(
                value: classe,
                child: Text(classe.nomClass),
              );
            }).toList(),
            decoration: const InputDecoration(labelText: "Select a Class"),
          ),
          if (selectedClass != null)
            Wrap(
              children: selectedClass!.matieres!.map((Matier matiere) {
                return ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedMatiere = matiere;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary:
                        selectedMatiere == matiere ? Colors.blue : Colors.grey,
                  ),
                  child: Text(matiere.matiereName),
                );
              }).toList(),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (date) {
                setState(() {
                  selectedDate = date;
                });
              },
              decoration: InputDecoration(labelText: 'Enter Date (YYYY-MM-DD)'),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (selectedClass != null &&
                  selectedMatiere != null &&
                  selectedDate != null) {
                await getByMatiereIdAndDateTotal(
                    selectedMatiere!, selectedDate!);
              }
            },
            child: Text('Fetch Students'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: absences?.length ?? 1,
              itemBuilder: (BuildContext context, int index) {
                if (absences != null) {
                  return Slidable(
                    key: Key(absences!.elementAt(index).absenceId.toString()),
                    startActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) async {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AbsenceDialog(
                                    notifyParent: refresh,
                                    getAllAbsence: getAbsenceByStudentId,
                                    matieres: selectedClass?.matieres,
                                    absence: Absence(
                                      absences?.elementAt(index).absenceNb,
                                      absences?.elementAt(index).date,
                                      selectedStudent,
                                      absences?.elementAt(index).matiere,
                                      absences?.elementAt(index).absenceId,
                                    ),
                                    modif: true,
                                  );
                                });
                          },
                          backgroundColor: const Color(0xFF21B7CA),
                          foregroundColor: Colors.white,
                          icon: Icons.edit,
                          label: 'Edit',
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    "Student name: ",
                                  ),
                                  Text(
                                    "${absences!.elementAt(index).etudiant?.nom} ${absences!.elementAt(index).etudiant?.prenom}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text("Hours number: "),
                                  Text(
                                    absences!
                                        .elementAt(index)
                                        .absenceNb
                                        .toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 2.0,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text("Matiere name: "),
                                  Text(
                                    absences
                                            ?.elementAt(index)
                                            .matiere
                                            ?.matiereName ??
                                        'N/A',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      backgroundColor: Colors.lightBlueAccent,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
                // show when selected student is null
                return const Text("No data available");
              },
            ),
          ),
        ],
      ),
    );
  }
}
