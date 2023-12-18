import 'package:flutterproject/entities/matier.dart';
import 'package:flutterproject/entities/student.dart';

class Absence {
  int? absenceId;
  double? absenceNb;
  String? date;
  Student? etudiant;
  Matier? matiere;

  Absence(this.absenceNb, this.date, this.etudiant, this.matiere,
      [this.absenceId]);

  // Factory method to create an Absence object from JSON
  factory Absence.fromJson(Map<String, dynamic> json) {
    return Absence(
        json['absenceNb'],
        json['date'],
        json.containsKey('etudiant')
            ? Student.fromJson(json['etudiant'])
            : null,
        json.containsKey('matiere') ? Matier.fromJson(json['matiere']) : null,
        json['absenceId']);
  }

  get totalAbsences => null;

  get someOtherProperty => null;

  // Add a method to convert the Absence object to JSON
  Map<String, dynamic> toJson() {
    return {
      'absenceNb': absenceNb,
      'date': date,
      'etudiant': etudiant,
      'matiere': matiere,
      'absenceId': absenceId,
    };
  }
}
