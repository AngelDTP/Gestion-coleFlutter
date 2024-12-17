import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class userProvider with ChangeNotifier {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String email = '';
  String matricule = '';
  String nom = '';
  String prenom = '';
  String image_url = '';
  String role = '';
  bool isFound = false;

  void logout() {
    FirebaseAuth.instance.signOut();
    email = '';
    matricule = '';
    nom = '';
    prenom = '';
    image_url = '';
    role = '';
    isFound = false;
    notifyListeners();
  }

  bool isAdmin() {
    if (role == 'Administrateur') {
      return true;
    }
    return false;
  }

  bool isTeacher() {
    if (role == 'Enseignant') {
      return true;
    }
    return false;
  }

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
  
  Future<Map<String, dynamic>?> getUserDataByEmail(String email) async {
    try {
      var userData = await _firestore
          .collection('utilisateurs')
          .where('email', isEqualTo: email)
          .get();
          
      if (userData.docs.isNotEmpty) {
        var userDataMap = userData.docs.first.data();
        email = userDataMap['email'] ?? '';
        matricule = userDataMap['matricule'] ?? '';
        nom = userDataMap['nom'] ?? '';
        prenom = userDataMap['prenom'] ?? '';
        image_url = userDataMap['image_url'] ?? '';
        role = userDataMap['role'] ?? '';
        isFound = true;

        notifyListeners();
        return userDataMap;
      }
    } catch (error) {
      print('Error fetching user data: $error');
      return null;
    }
    return null;
  }


  Future<void> updateMatricule(String nouvMatricule) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection('utilisateurs').doc(uid).update({
        'matricule': nouvMatricule,
      });
    } catch (e) {
      debugPrint('Erreur: $e');
    }
  }

  Future<void> updateNom(String newNom) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection('utilisateurs').doc(uid).update({
        'nom': newNom,
      });
    } catch (e) {
      debugPrint('Erreur: $e');
    }
  }

  Future<void> updatePrenom(String newPrenom) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection('utilisateurs').doc(uid).update({
        'prenom': newPrenom,
      });
    } catch (e) {
      debugPrint('Erreur: $e');
    }
  }

  void updateImageUrl(String imageURL) {
    image_url = imageURL;
    notifyListeners();
  }

  String get getEmail => email;
  String get getMatricule => matricule;
  String get getNom => nom;
  String get getPrenom => prenom;
  String get getImageUrl => image_url;
  get getRole => role;

  void setEmail(String email) {
    this.email = email;
    notifyListeners();
  }
}