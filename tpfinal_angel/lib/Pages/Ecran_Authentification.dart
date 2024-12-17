import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tpfinal_angel/Widgets/forms_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EcranAuthentification extends StatefulWidget {
  const EcranAuthentification({super.key});

  @override
  State<EcranAuthentification> createState() => _EcranAuthentificationState();
}

class _EcranAuthentificationState extends State<EcranAuthentification> {
  final auth = FirebaseAuth.instance;
  Future<void> _enregistrerUtilisateur(
    String matricule,
    String nom,
    String prenom,
    String email,
    String password,
    bool isLoggedIn,
    XFile? image,
    String role,
  ) async {
    UserCredential authResult;

    try {
      if (isLoggedIn) {
        authResult = await auth.signInWithEmailAndPassword(
          email: email,
          password: password
        );
      } else {
        authResult = await auth.createUserWithEmailAndPassword(
          email: email,
          password: password
        );

        final ref = FirebaseStorage.instance
            .ref()
            .child("user_image")
            .child(authResult.user!.uid + '.jpg');

        await ref.putFile(File(image!.path)).whenComplete((() => true));

        final myUserImageLink = await ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('utilisateurs')
            .doc(authResult.user!.uid)
            .set({
              'matricule': matricule,
              'nom': nom,
              'prenom': prenom,
              'email': email,
              'image_url': myUserImageLink,
              'role': role,
            });
      }
    }
    on FirebaseException catch (e) {
    var message = AppLocalizations.of(context)!.errorText;

    if (e.message != null) {
      message = e.message!;
    }

    ScaffoldMessenger.of(context)
      .showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.red,
              Colors.blue,
            ],
          ),
        ),
        child: form_auth(
          _enregistrerUtilisateur,
        ),
      ),
    );
  }
}