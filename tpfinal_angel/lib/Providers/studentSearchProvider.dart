import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentSearchProvider with ChangeNotifier {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String email = '';
  String matricule = '';
  String nom = '';
  String prenom = '';
  String role = '';
  String image_url = '';
  bool isFound = false;

  get getNom => nom;
  get getPrenom => prenom;
  get getMatricule => matricule;
  get getEmail => email;
  get getRole => role;
  get getImageUrl => image_url;

  bool getIsFound() => isFound;

  void setPrenom(String setPrenom) {
    prenom = setPrenom;
    notifyListeners();
  }

  void setNom(String setNom) {
    nom = setNom;
    notifyListeners();
  }

  void setMatricule(String setMatricule) {
    matricule = setMatricule;
    notifyListeners();
  }

  void setRole(String role) {
    this.role = role;
    notifyListeners();
  }

  Future<Map<String, dynamic>?> getUserByMatricule(String matricule) async {
    try {
      email = '';
      this.matricule = '';
      nom = '';
      prenom = '';
      image_url = '';
      isFound = false;

      var userData = await _firestore
          .collection('utilisateurs')
          .where('matricule', isEqualTo: matricule)
          .get();
          
      if (userData.docs.isNotEmpty) {
        var userDataMap = userData.docs.first.data() as Map<String, dynamic>;
        email = userDataMap['email'] ?? '';
        this.matricule = matricule;
        nom = userDataMap['nom'] ?? '';
        prenom = userDataMap['prenom'] ?? '';
        role = userDataMap['role'] ?? '';
        image_url = userDataMap['image_url'] ?? '';
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

  Future<void> updateMatricule(String nouvMatricule) async {
    await updateFieldByEmail('matricule', nouvMatricule);
  }

  Future<void> updateNom(String newNom) async {
    await updateFieldByEmail('nom', newNom);
  }

  Future<void> updatePrenom(String newPrenom) async {
    await updateFieldByEmail('prenom', newPrenom);
  }
  Future<void> updateRole(String role) async{
    await updateFieldByEmail('role', role);
  }

  Future<void> updateFieldByEmail(String field, String newValue) async {
    try {
      var users = await _firestore.collection('utilisateurs')
                   .where('email', isEqualTo: email)
                   .get();

      if (users.docs.isNotEmpty) {
        var docId = users.docs.first.id;
        await _firestore.collection('utilisateurs').doc(docId).update({
          field: newValue,
        });
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating user data by email: $e');
    }
  }
}
