import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PresenceProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> classesEnseignant = [];
  List<Map<String, dynamic>> etudiants = [];
  List<Map<String, dynamic>> presences = [];

  List<Map<String, dynamic>> rapportEtudiant = [];

  Map<String, dynamic> getEtudiantSelonEmail(String email) {
    return etudiants.firstWhere(
      (etudiant) => etudiant['email'] == email
    );
  }

  List<Map<String, dynamic>> get getClassesEnseignant => classesEnseignant;

  String get todayDate {
    final DateTime now = DateTime.now();
    final String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    return formattedDate;
  }

  Future<List<Map<String, dynamic>>?> recupererClasse(String email, String role) async {
    try {
      var querySnapshotClassFuture =  _firestore
          .collection('classes')
          .get();

      var querySnapshotEtudiantsFuture =  _firestore
          .collection('utilisateurs')
          .where('role', isEqualTo: 'Etudiant')
          .get();

      var querySnapshotPresencesFuture =  _firestore
          .collection('presences')
          .get();

      var querySnapshotClass = await querySnapshotClassFuture;
      var querySnapshotEtudiants = await querySnapshotEtudiantsFuture;
      var querySnapshotPresences = await querySnapshotPresencesFuture;

      if (querySnapshotClass.docs.isNotEmpty) {
        classesEnseignant = querySnapshotClass.docs.map((e) => e.data() as Map<String, dynamic>).toList();

        if (role == 'Enseignant') {
          classesEnseignant = classesEnseignant.where((classe) => classe['Enseignant'] == email).toList();
        }
      } else {
        classesEnseignant = [];
      }

      if (querySnapshotEtudiants.docs.isNotEmpty) {
        etudiants = querySnapshotEtudiants.docs.map((e) => e.data() as Map<String, dynamic>).toList();
      } else {
        etudiants = [];
      }

      if (querySnapshotPresences.docs.isNotEmpty) {
        presences = querySnapshotPresences.docs.map((e) => e.data() as Map<String, dynamic>).toList();
      } else {
        presences = [];
      }

      notifyListeners();

      return classesEnseignant;
    } catch (error) {
      print('Error fetching class data: $error');
      return null;
    }
  }

  Future<void> marquerPresence(etudiant, course, String jour) async {
    var presence = presences.firstWhere(
      (p) => p['Etudiants'] == etudiant && p['Num_Cours'] == course && p['Jour'] == jour,
      orElse: () => {},
    );

    if (presence.isEmpty) {
      _firestore.collection('presences').add({
        'Etudiants': etudiant,
        'Num_Cours': course,
        'Jour': jour,
        'Present': false,
      });

      presences.add({
        'Etudiants': etudiant,
        'Num_Cours': course,
        'Jour': jour,
        'Present': false,
      });
    }
    else {
      var presenceFirebase = await _firestore
          .collection('presences')
          .where('Etudiants', isEqualTo: etudiant)
          .where('Num_Cours', isEqualTo: course)
          .where('Jour', isEqualTo: jour)
          .get();

      if (presenceFirebase.docs.isNotEmpty) {
        var docId = presenceFirebase.docs.first.id;
        await _firestore.collection('presences').doc(docId).update({
          'Present': !presence['Present'],
        });
      }

      presences.firstWhere(
        (p) => p['Etudiants'] == etudiant && p['Num_Cours'] == course && p['Jour'] == jour,
        orElse: () => {},
      )['Present'] = !presence['Present'];
    }

    notifyListeners();
  }

  bool verificationPresent(String etudiant, String course, String jour) {
    var presence = presences.firstWhere(
      (p) => p['Etudiants'] == etudiant && p['Num_Cours'] == course && p['Jour'] == jour,
      orElse: () => {},
    );

    if (presence.isNotEmpty)
      return presence['Present'];
    else
      return true;
  }

  creationRapportEtudiant(String etudiant) {
    rapportEtudiant = [];

    var toutPresencesManques = presences.where((presence) => presence['Etudiants'] == etudiant && !presence['Present']).toList();

    var toutCoursManques = [];

    for (var presence in toutPresencesManques) {
      var cours = classesEnseignant.firstWhere(
        (classe) => classe['Num_Cours'] == presence['Num_Cours'],
        orElse: () => {},
      );

      var JourDuCours = cours['Periode_Cours'].firstWhere(
        (periode) => periode['Jour'] == presence['Jour'],
        orElse: () => {},
      );

      toutCoursManques.add(
        {
          'Num_Cours': presence['Num_Cours'],
          'Jour': presence['Jour'],
          'Heure_Debut': JourDuCours['Heure_Debut'],
          'Heure_Fin': JourDuCours['Heure_Fin'],
        }
      );
    }

    for (var cours in toutCoursManques) {
      DateTime startTime = DateTime.parse(cours['Jour'] + ' ' + cours['Heure_Debut']);
      DateTime endTime = DateTime.parse(cours['Jour'] + ' ' + cours['Heure_Fin']);

      int differenceInMinutes = endTime.difference(startTime).inMinutes;
      
      rapportEtudiant.add(
        {
          'Num_Cours': cours['Num_Cours'],
          'Jour': cours['Jour'],
          'Heure_Debut': cours['Heure_Debut'],
          'Heure_Fin': cours['Heure_Fin'],
          'Duree': differenceInMinutes,
        }
      );
    }

    notifyListeners();
  }

  videCreationRapportEtudiant() {
    rapportEtudiant = [];
    notifyListeners();
  }

  get getRapportEtudiant => rapportEtudiant;
}