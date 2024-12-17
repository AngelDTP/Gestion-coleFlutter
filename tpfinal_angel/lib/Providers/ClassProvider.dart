import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tpfinal_angel/Providers/userProvider.dart';

class ClassProvider with ChangeNotifier {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String modeDePage = '';
  var allStudents = [];

  String enseignant = '';
  String nomClasse = '';
  num numeroClasse = 0;
  var periode_cours = [];
  var etudiants = [];

  bool isFound = false;
  bool searchMade = false;

  var heuresDebutPossibles = [
    '08:00',
    '08:55',
    '09:50',
    '10:45',
    '11:40',
    '12:35',
    '13:30',
    '14:25',
    '15:20',
    '16:15',
    '17:10',
  ];

  var heuresFinPossibles = [
    '08:50',
    '09:45',
    '10:40',
    '11:35',
    '12:30',
    '13:25',
    '14:20',
    '15:15',
    '16:10',
    '17:05',
    '18:00',
  ];

  get getSearchMade {
    return searchMade;
  }

  void setSearchMade(bool reponse) {
    searchMade = reponse;
    notifyListeners();
  }

  void setModeDePage(String mode) {
    modeDePage = mode;
    notifyListeners();
  }

  get getModeDePage {
    return modeDePage;
  }

  get getAllStudentsList {
    return allStudents;
  }

  Future<List<Map<String, dynamic>>?> getAllTeachers() async {
    try {
      var userData = await _firestore
          .collection('utilisateurs')
          .where('role', isEqualTo: 'Enseignant')
          .get();

      if (userData.docs.isNotEmpty) {
        List<Map<String, dynamic>> teachersData = [];
        
        for (var doc in userData.docs) {
          var userDataMap = doc.data() as Map<String, dynamic>;
          teachersData.add(userDataMap);
        }

        print(teachersData);

        notifyListeners();
        return teachersData;
      }
    } catch (error) {
      print('Error fetching teachers data: $error');
      notifyListeners();
      return null;
    }
    notifyListeners();
    return null;
  }

  void creerClasse(String nomClasse, num numeroClasse, selectedTeacher) {
    _firestore.collection('classes').add({
      'Num_Cours': nomClasse,
      'Num_Groupe': numeroClasse,
      'Enseignant': selectedTeacher,
      'Etudiants': [],
      'Periode_Cours': []
    });

    modeDePage = '';

    notifyListeners();
  }

  Future<Map<String, dynamic>?> recupererClasse(String nomClasse, num numeroClasse, userProvider enseignantClasse) async {
    try{

      var userData;

      if (enseignantClasse.getRole == 'Enseignant') {
        userData = await _firestore
          .collection('classes')
          .where('Num_Cours', isEqualTo: nomClasse)
          .where('Num_Groupe', isEqualTo: numeroClasse)
          .where('Enseignant', isEqualTo: enseignantClasse.getEmail)
          .get();
      } else {
        userData = await _firestore
          .collection('classes')
          .where('Num_Cours', isEqualTo: nomClasse)
          .where('Num_Groupe', isEqualTo: numeroClasse)
          .get();
      }
        
      searchMade = true;

      print(userData.docs);

      if (userData.docs.isNotEmpty) {
        var userDataMap = userData.docs.first.data() as Map<String, dynamic>;
        nomClasse = userDataMap['Num_Cours'];
        numeroClasse = userDataMap['Num_Groupe'];
        periode_cours = userDataMap['Periode_Cours'];
        etudiants = userDataMap['Etudiants'];
        enseignant = userDataMap['Enseignant'];
        isFound = true;

        notifyListeners();
        return userDataMap;
      }
    } catch (error) {
      print('Error fetching user data: $error');
      isFound = false;
      notifyListeners();
      return null;
    }
    isFound = false;
    notifyListeners();
    return null;
  }

  void changementCours() {
    enseignant = '';
    nomClasse = '';
    numeroClasse = 0;
    periode_cours = [];
    etudiants = [];
    isFound = false;
    searchMade = false;

    notifyListeners();
  }

  Future<void> ajouterPeriodeCours(String nomDeLaClasse, num numeroDeLaClasse, String jourCalendrier, String hereDebut, String heureFin) async {
    try {
      var classe = await _firestore
          .collection('classes')
          .where('Num_Cours', isEqualTo: nomDeLaClasse)
          .where('Num_Groupe', isEqualTo: numeroDeLaClasse)
          .get();

      periode_cours.add({
        'Jour': jourCalendrier,
        'Heure_Debut': hereDebut,
        'Heure_Fin': heureFin
      });

      if (classe.docs.isNotEmpty) {
        var docId = classe.docs.first.id;
        await _firestore.collection('classes').doc(docId).update({
          'Periode_Cours': periode_cours,
        });

        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating class periods: $e');
    }
  }

  Future<List<Map<String, dynamic>>?> getAllStudents() async{
    try {
      var userData = await _firestore
          .collection('utilisateurs')
          .where('role', isEqualTo: 'Etudiant')
          .get();

      if (userData.docs.isNotEmpty) {
        List<Map<String, dynamic>> students = [];
        
        for (var doc in userData.docs) {
          var userDataMap = doc.data() as Map<String, dynamic>;
          students.add(userDataMap);
        }

        print(etudiants);

        allStudents = students;

        notifyListeners();
        return students;
      }
    } catch (error) {
      print('Error fetching teachers data: $error');
      notifyListeners();
      return null;
    }
    notifyListeners();
    return null;
  }

  Future<void> ajouterEtudiantsCours() async {
    try {
      var classe = await _firestore
          .collection('classes')
          .where('Num_Cours', isEqualTo: nomClasse)
          .where('Num_Groupe', isEqualTo: numeroClasse)
          .get();

      if (classe.docs.isNotEmpty) {
        var docId = classe.docs.first.id;
        await _firestore.collection('classes').doc(docId).update({
          'Etudiants': etudiants,
        });
        nomClasse = '';
        numeroClasse = 0;
        periode_cours = [];
        etudiants = [];
        isFound = false;
        searchMade = false;

        modeDePage = '';

        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating class students: $e');
    }
  }

  getEtudiantsCours() {
    return etudiants;
  }

  void setEnseignant(classData) {
    enseignant = classData;
    notifyListeners();
  }

  void setNomCours(classData) {
    nomClasse = classData;
    notifyListeners();
  }

  void setNumeroClasse(classData) {
    numeroClasse = classData;
    notifyListeners();
  }

  void setPeriodeCours(classData) {
    periode_cours = classData;
    notifyListeners();
  }

  void setEtudiants(classData) {
    etudiants = classData;
    notifyListeners();
  }

  void setIsFound(bool bool) {
    isFound = bool;
    notifyListeners();
  }

  void toggleEtudiantCours(student) {
    if (etudiants.contains(student)) {
      etudiants.remove(student);
    } else {
      etudiants.add(student);
    }
    print(etudiants);

    notifyListeners();
  }

  retourDebut() {
    enseignant = '';
    nomClasse = '';
    numeroClasse = 0;
    periode_cours = [];
    etudiants = [];
    isFound = false;
    searchMade = false;
    modeDePage = '';

    notifyListeners();
  }

  List<String> getHeuresDebutPossibles() {
  return heuresDebutPossibles;
}

List<String> getHeuresFinPossibles() {
  return heuresFinPossibles;
}

  bool verificationHeureFin(String tempsDebut, String tempsFin) {
    if (heuresDebutPossibles.indexOf(tempsDebut) >= heuresFinPossibles.indexOf(tempsFin)) {
      return true;
    }
    return false;
  }

  bool verificationHeureDebut(String tempsDebut, String tempsFin) {
    if (heuresFinPossibles.indexOf(tempsFin) <= heuresDebutPossibles.indexOf(tempsDebut)) {
      return true;
    }
    return false;
  }
}