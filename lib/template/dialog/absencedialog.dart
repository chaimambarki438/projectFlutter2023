import 'package:flutter/material.dart';
import 'package:flutterproject/services/classeservice.dart';
import 'package:intl/intl.dart';
import 'package:flutterproject/entities/absence.dart';
import 'package:flutterproject/entities/matier.dart';

class AbsenceDialog extends StatefulWidget {
  final Function()? notifyParent;
  final Function()? getAllAbsence;
  Absence? absence;
  List<Matier>? matieres;
  bool? modif = false;

  AbsenceDialog({
    super.key,
    @required this.notifyParent,
    this.getAllAbsence,
    this.matieres,
    this.absence,
    this.modif,
  });
  @override
  State<AbsenceDialog> createState() => AbsenceDialogState();
}

class AbsenceDialogState extends State<AbsenceDialog> {
  TextEditingController nbhAbsence = TextEditingController();
  TextEditingController dateAbsence = TextEditingController();

  List<Matier>? matiers;
  Matier? selectedMatiere;

  Absence? absence;

  String title = "Ajouter Absence";
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        DateTime pickedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        String formattedDateTime =
            DateFormat("yyyy-MM-ddTHH:mm:ss").format(pickedDateTime);

        setState(() {
          dateAbsence.text = formattedDateTime;
          selectedDate = pickedDateTime;
        });
      }
    }
  }

  @override
  void initState() {
    matiers = widget.matieres;
    absence = widget.absence;

    super.initState();

    if (widget.absence != null) {
      title = "ajouter Absence"; // Change title for modification
      nbhAbsence.text = (widget.absence?.absenceNb).toString();
      dateAbsence.text = (widget.absence?.date).toString();
      selectedMatiere = widget.absence?.matiere;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: Color.fromARGB(255, 176, 101, 39),
              ),
            ),
            TextFormField(
              controller: nbhAbsence,
              validator: (String? value) {
                if (value!.isEmpty) {
                  return "Champs est obligatoire";
                }
                return null;
              },
              decoration: InputDecoration(labelText: "Nombre d'heures"),
            ),
            TextFormField(
              controller: dateAbsence,
              readOnly: true,
              decoration: InputDecoration(labelText: "Date d'absence"),
              onTap: () {
                _selectDate(context);
              },
            ),
            DropdownButtonFormField<Matier>(
              value: selectedMatiere,
              onChanged: (Matier? value) {
                setState(() {
                  selectedMatiere = value;
                });
              },
              items: matiers?.map((Matier matiere) {
                return DropdownMenuItem<Matier>(
                  value: matiere,
                  child: Text(matiere.matiereName),
                );
              }).toList(),
              decoration: InputDecoration(labelText: "Matière"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (widget.modif == false) {
                  await addAbsence(Absence(
                    double.parse(nbhAbsence.text),
                    dateAbsence.text,
                    null,
                    selectedMatiere,
                  ));
                } else {
                  await updateAbsence(Absence(
                    double.parse(nbhAbsence.text),
                    dateAbsence.text,
                    absence?.etudiant,
                    selectedMatiere,
                    absence?.absenceId,
                  ));
                }
                widget.getAllAbsence!();
                widget.notifyParent!();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                primary: const Color.fromARGB(255, 251, 232, 64),
              ),
              child: const Text(
                "Ajouter",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
